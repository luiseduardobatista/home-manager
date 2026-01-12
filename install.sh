#!/bin/bash

set -e

CURRENT_USER=$(whoami)

detect_distro() {
	echo "Iniciando a detecção da distribuição do sistema..."
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		DISTRO_ID="$ID"
	else
		echo "Não foi possível detectar a distribuição. Saindo."
		exit 1
	fi
	echo "Distribuição detectada: $DISTRO_ID"
}

install_system_dependencies() {
	echo "Verificando e instalando dependências essenciais do sistema..."
	case "$DISTRO_ID" in
	ubuntu | debian | pop)
		sudo apt-get update
		sudo apt-get install -y \
			git curl python3-venv vim wl-clipboard \
			meson ninja-build pkg-config build-essential \
			libwayland-dev libwayland-bin wayland-protocols \
			libpixman-1-dev libxkbcommon-dev \
			libfontconfig1-dev libutf8proc-dev libtllist-dev \
			scdoc
		;;
	fedora)
		sudo dnf install -y \
			git curl python3 vim wl-clipboard \
			meson ninja-build \
			wayland-devel wayland-protocols-devel \
			pixman-devel libxkbcommon-devel \
			scdoc pkgconf-pkg-config gcc
		;;
	arch)
		sudo pacman -Syu --noconfirm \
			git curl python vim wl-clipboard \
			meson ninja \
			wayland wayland-protocols \
			pixman libxkbcommon \
			scdoc pkgconf base-devel
		;;
	*)
		echo "Distribuição não suportada: $DISTRO_ID"
		echo "Por favor, instale manualmente: git, curl, python."
		exit 1
		;;
	esac
}

install_nix() {
	echo "Verificando a instalação do Nix e iniciando o processo se necessário..."
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

configure_nix_daemon() {
	echo "Configurando e iniciando o daemon Nix para ambientes sem systemd..."
	if ! [ -d /run/systemd/system ]; then
		echo "Ambiente sem systemd detectado. Configurando e iniciando o nix-daemon..."

		sudo mkdir -p /etc/nix
		echo "trusted-users = root $CURRENT_USER" | sudo tee /etc/nix/nix.conf
		echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

		sudo /nix/var/nix/profiles/default/bin/nix-daemon &

		echo "Aguardando o nix-daemon iniciar..."
		local NIX_DAEMON_SOCKET="/nix/var/nix/daemon-socket/socket"
		local MAX_ATTEMPTS=10
		local ATTEMPT=0
		while [ ! -S "$NIX_DAEMON_SOCKET" ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
			echo "Aguardando o socket do nix-daemon ($NIX_DAEMON_SOCKET)... Tentativa $((ATTEMPT + 1)) de $MAX_ATTEMPTS"
			sleep 1
			ATTEMPT=$((ATTEMPT + 1))
		done

		if [ ! -S "$NIX_DAEMON_SOCKET" ]; then
			echo "Erro: O socket do nix-daemon não apareceu após várias tentativas. Saindo."
			exit 1
		fi
		echo "Nix-daemon está ativo e pronto."
	fi
}

apply_home_manager_config() {
	echo "Aplicando a configuração do Home Manager para o usuário '$CURRENT_USER'..."
	USER=$CURRENT_USER nix shell nixpkgs#home-manager -c home-manager switch --flake .#"$CURRENT_USER"
}

set_default_shell() {
	echo "Definindo o shell padrão para o usuário..."
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
		echo "Adicionando '$SHELL_PATH' a /etc/shells..."
		echo "$SHELL_PATH" | sudo tee -a /etc/shells >/dev/null
		echo "'$SHELL_PATH' adicionado com sucesso a /etc/shells."
	else
		echo "'$SHELL_PATH' já está presente em /etc/shells. Pulando a adição."
	fi

	if [ "$SHELL" != "$SHELL_PATH" ]; then
		echo "Definindo $shell_choice como o shell padrão para $CURRENT_USER..."
		sudo usermod -s "$SHELL_PATH" "$CURRENT_USER"
	else
		echo "$shell_choice já é o shell padrão."
	fi

	if [ "$shell_choice" = "fish" ]; then
		echo "Instalando o Fisher para o shell fish..."
		fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher"
		fish -c "fisher install kidonng/zoxide.fish"
	fi
	echo "Instalando o Starship Prompt..."
	curl -sS https://starship.rs/install.sh | sh -s -- -y
	export PATH="$HOME/.nix-profile/bin:$PATH"
	starship preset nerd-font-symbols -o ~/.config/starship.toml

}

configure_rust() {
	echo "Configurando a toolchain padrão do Rust como 'stable'..."
	if rustup default stable; then
		echo "Toolchain padrão do Rust definida como 'stable' com sucesso."
	else
		echo "Erro ao definir a toolchain padrão do Rust. Por favor, verifique a instalação do rustup."
	fi
}

install_neovim() {
	echo "--- Instalando Neovim (Latest Stable) ---"
	if [ -f /usr/local/bin/nvim ]; then
		sudo rm /usr/local/bin/nvim
	fi
	echo "Baixando AppImage..."
	sudo curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -o /usr/local/bin/nvim
	if [ $? -eq 0 ]; then
		sudo chmod +x /usr/local/bin/nvim
		echo "Neovim instalado com sucesso: $(/usr/local/bin/nvim --version | head -n 1)"
	else
		echo "ERRO: Falha ao baixar o Neovim."
		exit 1
	fi
}

main() {
	detect_distro
	install_system_dependencies
	install_nix
	configure_nix_daemon
	apply_home_manager_config
	set_default_shell
	configure_rust
	# install_neovim

	echo ""
	echo "Configuração concluída!"
	echo ""
}

main
