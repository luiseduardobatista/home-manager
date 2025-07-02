#!/bin/bash
set -e

# Define o usuário atual de forma robusta
CURRENT_USER=$(whoami)

# Este script automatiza a configuração do ambiente de desenvolvimento em novas instalações
# do Ubuntu, Fedora e Arch Linux. Ele é projetado para ser idempotente.
#
# O script irá:
# 1. Detectar a distribuição (distro).
# 2. Instalar dependências de sistema necessárias usando o gerenciador de pacotes correto.
# 3. Instalar o gerenciador de pacotes Nix, caso ainda não esteja instalado.
# 4. Aplicar a configuração do Home Manager a partir do flake no diretório atual.
# 5. Solicitar ao usuário que selecione um shell padrão (Bash, Zsh ou Fish).
# 6. Configurar a toolchain padrão do Rust.

# --- Passo 1: Detecção da Distro ---
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO_ID="$ID"
else
  echo "Não foi possível detectar a distribuição. Saindo."
  exit 1
fi

echo "Distribuição detectada: $DISTRO_ID"

# --- Passo 2: Instalar Dependências do Sistema ---
echo "Garantindo que as dependências do sistema estejam instaladas..."
case "$DISTRO_ID" in
ubuntu | debian)
  sudo apt-get update
  sudo apt-get install -y git curl python3-venv
  ;;
fedora)
  sudo dnf install -y git curl python3
  ;;
arch)
  sudo pacman -Syu --noconfirm git curl python
  ;;
*)
  echo "Distribuição não suportada: $DISTRO_ID"
  echo "Por favor, instale manualmente: git, curl, python."
  exit 1
  ;;
esac

# --- Passo 3: Instalar o Gerenciador de Pacotes Nix ---
if ! command -v nix &>/dev/null; then
  echo "Nix não encontrado. Instalando o gerenciador de pacotes Nix..."

  # Prepara os argumentos para o instalador do Nix
  INSTALLER_ARGS=""

  # Verifica se o systemd está ativo. Se não estiver (comum em contêineres Docker),
  # instrui o instalador a não configurar um serviço de init.
  if ! [ -d /run/systemd/system ]; then
    echo "Systemd não detectado. Instalando o Nix sem configurar o serviço de daemon."
    INSTALLER_ARGS="linux --init none"
  fi

  # Executa o instalador do Nix com os argumentos apropriados
  # Baixa o instalador do Nix, torna-o executável e o executa.
  # Esta abordagem é mais robusta do que o pipe 'curl | sh'.
  echo "Baixando o instalador do Nix para /tmp..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /tmp/nix-installer
  chmod +x /tmp/nix-installer

  echo "Executando o instalador do Nix..."
  /tmp/nix-installer install $INSTALLER_ARGS --no-confirm

  # Limpa o instalador
  rm /tmp/nix-installer

  # Carrega o ambiente Nix para a sessão atual do script
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "O Nix já está instalado. Pulando a instalação."
fi

# --- Passo 3.5: Configurar e Iniciar o Daemon (para ambientes sem systemd) ---
# Em ambientes como Docker, o nix-daemon não é iniciado automaticamente.
if ! [ -d /run/systemd/system ]; then
  echo "Ambiente sem systemd detectado. Configurando e iniciando o nix-daemon..."

  # Garante que o diretório de configuração do Nix exista
  sudo mkdir -p /etc/nix

  # Adiciona o usuário atual aos usuários confiáveis para que ele possa usar o daemon
  # e habilita as features experimentais necessárias para flakes.
  echo "trusted-users = root $CURRENT_USER" | sudo tee /etc/nix/nix.conf
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

  # Inicia o daemon do Nix em segundo plano
  sudo /nix/var/nix/profiles/default/bin/nix-daemon &

  # Aguarda um momento para o daemon iniciar e criar o socket de comunicação
  echo "Aguardando o nix-daemon iniciar..."
  sleep 5
fi

# --- Passo 4: Aplicar a Configuração do Home Manager ---
echo "Aplicando a configuração do Home Manager para o usuário '$CURRENT_USER'..."
USER=$CURRENT_USER nix shell nixpkgs#home-manager -c home-manager switch --flake .#"$CURRENT_USER"

# --- Passo 5: Definir o Shell Padrão ---
# Verifica se estamos em um ambiente não interativo (como o Docker)
if ! [ -d /run/systemd/system ]; then
  echo "Ambiente não interativo detectado. Definindo 'zsh' como o shell padrão..."
  SHELL_PATH="$HOME/.nix-profile/bin/zsh"
  shell_choice="zsh"
else
  # Se estiver em um sistema completo, permite a seleção interativa
  echo "Por favor, escolha seu shell padrão:"
  select shell_choice in "bash" "zsh" "fish"; do
    case $shell_choice in
    bash)
      SHELL_PATH="/bin/bash"
      break
      ;;
    zsh)
      SHELL_PATH="$HOME/.nix-profile/bin/zsh"
      break
      ;;
    fish)
      SHELL_PATH="$HOME/.nix-profile/bin/fish"
      break
      ;;
    *)
      echo "Opção inválida. Por favor, tente novamente."
      ;;
    esac
  done
fi

# Adiciona o shell escolhido em /etc/shells se ainda não estiver presente
if ! grep -qxF "$SHELL_PATH" /etc/shells; then
  echo "Adicionando $SHELL_PATH em /etc/shells..."
  echo "$SHELL_PATH" | sudo tee -a /etc/shells
else
  echo "$SHELL_PATH já está presente em /etc/shells."
fi

# Define o shell escolhido como padrão se ainda não for
if [ "$SHELL" != "$SHELL_PATH" ]; then
  echo "Definindo $shell_choice como o shell padrão para $CURRENT_USER..."
  sudo usermod -s "$SHELL_PATH" "$CURRENT_USER"
else
  echo "$shell_choice já é o shell padrão."
fi

# --- Passo 6: Configurar o Rust ---
echo "Definindo a toolchain padrão do Rust como 'stable'..."
rustup default stable

# --- Finalização ---
echo ""
echo "Configuração concluída!"
echo ""
