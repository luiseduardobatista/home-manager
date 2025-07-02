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

# Função para detectar a distribuição
detect_distro() {
  echo "--- Passo 1: Detecção da Distro ---"
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="$ID"
  else
    echo "Não foi possível detectar a distribuição. Saindo."
    exit 1
  fi
  echo "Distribuição detectada: $DISTRO_ID"
}

# Função para instalar dependências do sistema
install_system_dependencies() {
  echo "--- Passo 2: Instalar Dependências do Sistema ---"
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
}

# Função para instalar o Nix
install_nix() {
  echo "--- Passo 3: Instalar o Gerenciador de Pacotes Nix ---"
  if ! command -v nix &>/dev/null; then
    echo "Nix não encontrado. Instalando o gerenciador de pacotes Nix..."

    INSTALLER_ARGS=""
    if ! [ -d /run/systemd/system ]; then
      echo "Systemd não detectado. Instalando o Nix sem configurar o serviço de daemon."
      INSTALLER_ARGS="linux --init none"
    fi

    echo "Baixando o instalador do Nix para /tmp..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /tmp/nix-installer
    chmod +x /tmp/nix-installer

    echo "Executando o instalador do Nix..."
    /tmp/nix-installer install $INSTALLER_ARGS --no-confirm

    rm /tmp/nix-installer

    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  else
    echo "O Nix já está instalado. Pulando a instalação."
  fi
}

# Função para configurar e iniciar o daemon Nix (para ambientes sem systemd)
configure_nix_daemon() {
  echo "--- Passo 3.5: Configurar e Iniciar o Daemon (para ambientes sem systemd) ---"
  if ! [ -d /run/systemd/system ]; then
    echo "Ambiente sem systemd detectado. Configurando e iniciando o nix-daemon..."

    sudo mkdir -p /etc/nix
    echo "trusted-users = root $CURRENT_USER" | sudo tee /etc/nix/nix.conf
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

    sudo /nix/var/nix/profiles/default/bin/nix-daemon &

    echo "Aguardando o nix-daemon iniciar..."
    sleep 5
  fi
}

# Função para aplicar a configuração do Home Manager
apply_home_manager_config() {
  echo "--- Passo 4: Aplicar a Configuração do Home Manager ---"
  echo "Aplicando a configuração do Home Manager para o usuário '$CURRENT_USER'..."
  USER=$CURRENT_USER nix shell nixpkgs#home-manager -c home-manager switch --flake .#"$CURRENT_USER"
}

# Função para definir o shell padrão
set_default_shell() {
  echo "--- Passo 5: Definir o Shell Padrão ---"
  if ! [ -d /run/systemd/system ]; then
    echo "Ambiente não interativo detectado. Definindo 'zsh' como o shell padrão..."
    SHELL_PATH="$HOME/.nix-profile/bin/zsh"
    shell_choice="zsh"
  else
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

  if ! grep -qxF "$SHELL_PATH" /etc/shells; then
    echo "Adicionando $SHELL_PATH em /etc/shells..."
    echo "$SHELL_PATH" | sudo tee -a /etc/shells
  else
    echo "$SHELL_PATH já está presente em /etc/shells."
  fi

  if [ "$SHELL" != "$SHELL_PATH" ]; then
    echo "Definindo $shell_choice como o shell padrão para $CURRENT_USER..."
    sudo usermod -s "$SHELL_PATH" "$CURRENT_USER"
  else
    echo "$shell_choice já é o shell padrão."
  fi
}

# Função para configurar o Rust
configure_rust() {
  echo "--- Passo 6: Configurar o Rust ---"
  echo "Definindo a toolchain padrão do Rust como 'stable'..."
  rustup default stable
}

# Função principal
main() {
  detect_distro
  install_system_dependencies
  install_nix
  configure_nix_daemon
  apply_home_manager_config
  set_default_shell
  configure_rust

  echo ""
  echo "Configuração concluída!"
  echo ""
}

# Executa a função principal
main

