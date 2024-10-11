#!/bin/bash

sudo curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Clona o repositório de dotfiles na home do usuário
git clone --recurse-submodules git@github:luiseduardobatista/dotfiles.git ~/dotfiles

for dir in ~/dotfiles/*/; do
  stow "${dir##*/}" --dir=~/dotfiles
done

home-manager switch --flake .

# Configura o Zsh como shell padrão
sudo echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells
sudo usermod -s ~/.nix-profile/bin/zsh "$USER"

rustup default stable
sudo apt install python3-venv -y

# Cria link simbólico para usar o wezterm como terminal padrão caso queira
# sudo ln -s ~/.nix-profile/bin/wezterm /usr/local/bin/wezterm
# sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/wezterm 20

exec $SHELL -l
