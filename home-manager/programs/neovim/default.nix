{
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
  xdg.configFile."nvim/init.lua".enable = false;

  home.packages = with pkgs-unstable; [
    gcc
    nodejs
    tree-sitter
  ];

  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env bash
    set -euo pipefail
    NVIM_DOTFILES_DIR="${config.home.homeDirectory}/.config/nvim"
    mkdir -p "$(dirname "$NVIM_DOTFILES_DIR")"
    if [ ! -d "$NVIM_DOTFILES_DIR/.git" ]; then
      echo "Clonando o repositório MiniMax em $NVIM_DOTFILES_DIR..."
      ${pkgs-unstable.git}/bin/git clone https://github.com/luiseduardobatista/MiniMax.git "$NVIM_DOTFILES_DIR"
      echo "Alterando a URL do remote 'origin' para a versão SSH..."
      ${pkgs-unstable.git}/bin/git -C "$NVIM_DOTFILES_DIR" remote set-url origin git@github.com:luiseduardobatista/minimax.git
    else
      echo "O repositório nvim já existe. Pulando o clone e a alteração de URL."
    fi
  '';

  home.activation.cloneLazyVim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env bash
    set -euo pipefail
    NVIM_DOTFILES_DIR="${config.home.homeDirectory}/.config/lvim"
    mkdir -p "$(dirname "$NVIM_DOTFILES_DIR")"
    if [ ! -d "$NVIM_DOTFILES_DIR/.git" ]; then
      echo "Clonando o repositório lazyvim em $NVIM_DOTFILES_DIR..."
      ${pkgs-unstable.git}/bin/git clone https://github.com/luiseduardobatista/lazyvim.git "$NVIM_DOTFILES_DIR"
      echo "Alterando a URL do remote 'origin' para a versão SSH..."
      ${pkgs-unstable.git}/bin/git -C "$NVIM_DOTFILES_DIR" remote set-url origin git@github.com:luiseduardobatista/lazyvim.git
    else
      echo "O repositório lazyvim já existe. Pulando o clone e a alteração de URL."
    fi
  '';
}
