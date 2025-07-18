{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  isNixOS,
  ...
}: {
  targets.genericLinux.enable = true;
  nixGL.packages = nixGL.packages;

  imports =
    [
      ./desktop/gnome/gnome.nix # Desabilite para o build em Docker
      ./programs/git.nix
      ./programs/ssh.nix
      ./packages/main.nix
      ./dotfiles/main.nix
    ]
    ++ (
      if isNixOS
      then [
        ./programs/zsh.nix
      ]
      else []
    );

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "wezterm";
      NIXOS_OZONE_WL = 1;
    };
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";

  home.activation.cloneLazyVim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env bash
    set -euo pipefail
    NVIM_DOTFILES_DIR="${config.home.homeDirectory}/nix/home-manager/dotfiles/nvim"
    # Ensure the parent directory exists
    mkdir -p "$(dirname "$NVIM_DOTFILES_DIR")"
    if [ ! -d "$NVIM_DOTFILES_DIR/.git" ]; then
      echo "Cloning lazyvim repository into dotfiles project at $NVIM_DOTFILES_DIR..."
      ${pkgs.git}/bin/git clone https://github.com/luiseduardobatista/lazyvim.git "$NVIM_DOTFILES_DIR"
    else
      echo "lazyvim repository already exists in the dotfiles project. Skipping clone."
    fi
  '';
}
