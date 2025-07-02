#!/bin/bash
set -e

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

# --- Passo 1: Detecção da Distro e Definição do Gerenciador de Pacotes ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="$ID"
else
    echo "Não foi possível detectar a distribuição. Saindo."
    exit 1
fi

echo "Distribuição detectada: $DISTRO_ID"

case "$DISTRO_ID" in
    ubuntu|debian)
        PACKAGE_MANAGER="sudo apt-get update && sudo apt-get install -y"
        PACKAGES="git curl python3-venv"
        ;;
    fedora)
        PACKAGE_MANAGER="sudo dnf install -y"
        PACKAGES="git curl python3"
        ;;
    arch)
        PACKAGE_MANAGER="sudo pacman -Syu --noconfirm"
        PACKAGES="git curl python"
        ;;
    *)
        echo "Distribuição não suportada: $DISTRO_ID"
        echo "Por favor, instale manualmente: git, curl, python."
        exit 1
        ;;
esac

# --- Passo 2: Instalar Dependências do Sistema ---
echo "Garantindo que as dependências do sistema estejam instaladas..."
$PACKAGE_MANAGER $PACKAGES

# --- Passo 3: Instalar o Gerenciador de Pacotes Nix ---
if ! command -v nix &> /dev/null; then
    echo "Nix não encontrado. Instalando o gerenciador de pacotes Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    echo "O Nix já está instalado. Pulando a instalação."
fi

# --- Passo 4: Aplicar a Configuração do Home Manager ---
echo "Aplicando a configuração do Home Manager para o usuário 'luisb'..."
nix shell nixpkgs#home-manager -c home-manager switch --flake .#luisb

# --- Passo 5: Definir o Shell Padrão ---
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

# Adiciona o shell escolhido em /etc/shells se ainda não estiver presente
if ! grep -qxF "$SHELL_PATH" /etc/shells; then
    echo "Adicionando $SHELL_PATH em /etc/shells..."
    echo "$SHELL_PATH" | sudo tee -a /etc/shells
else
    echo "$SHELL_PATH já está presente em /etc/shells."
fi

# Define o shell escolhido como padrão se ainda não for
if [ "$SHELL" != "$SHELL_PATH" ]; then
    echo "Definindo $shell_choice como o shell padrão para $USER..."
    sudo usermod -s "$SHELL_PATH" "$USER"
else
    echo "$shell_choice já é o shell padrão."
fi

# --- Passo 6: Configurar o Rust ---
echo "Definindo a toolchain padrão do Rust como 'stable'..."
rustup default stable

# --- Finalização ---
echo ""
echo "Configuração concluída!"
echo "Para aplicar todas as mudanças, por favor, faça logout e login novamente."
echo "Você pode iniciar uma nova sessão do $shell_choice agora executando: exec $(basename $SHELL_PATH) -l"
