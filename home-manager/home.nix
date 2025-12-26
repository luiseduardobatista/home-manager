{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  isNixOS,
  ...
}:
{
  targets.genericLinux.enable = true;
  nixGL.packages = nixGL.packages;

  imports = [
    ./desktop/gnome/gnome.nix # Desabilite para o build em Docker
    ./programs/git.nix
    ./programs/ssh.nix
    ./packages/main.nix
    ./dotfiles/main.nix
  ]
  ++ (
    if isNixOS then
      [
        ./programs/zsh.nix
      ]
    else
      [ ]
  );

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "foot";
      NIXOS_OZONE_WL = 1;
    };
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";

  home.activation.cloneLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #!/usr/bin/env bash
    set -euo pipefail
    NVIM_DOTFILES_DIR="${config.home.homeDirectory}/nix/home-manager/dotfiles/nvim"
    mkdir -p "$(dirname "$NVIM_DOTFILES_DIR")"
    if [ ! -d "$NVIM_DOTFILES_DIR/.git" ]; then
      echo "Clonando o repositório lazyvim em $NVIM_DOTFILES_DIR..."
      ${pkgs.git}/bin/git clone https://github.com/luiseduardobatista/lazyvim.git "$NVIM_DOTFILES_DIR"
      echo "Alterando a URL do remote 'origin' para a versão SSH..."
      ${pkgs.git}/bin/git -C "$NVIM_DOTFILES_DIR" remote set-url origin git@github.com:luiseduardobatista/lazyvim.git
    else
      echo "O repositório lazyvim já existe. Pulando o clone e a alteração de URL."
    fi
  '';
}
