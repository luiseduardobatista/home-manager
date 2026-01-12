{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  isNixOS,
  repoDir,
  ...
}:
{
  targets.genericLinux.enable = !isNixOS;
  targets.genericLinux.nixGL.packages = lib.mkIf (!isNixOS) nixGL.packages;

  imports = [
    ./lib/helpers.nix
    ./desktop/gnome/gnome.nix # Desabilite para o build em Docker

    ./programs
    ./packages/main.nix
    ./dotfiles/main.nix
  ];

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      NIXOS_OZONE_WL = 1;
    }
    // (
      if isNixOS then
        {
          GTK_IM_MODULE = "simple";
          QT_IM_MODULE = "simple";
          XMODIFIERS = "@im=none";
        }
      else
        { }
    );
  };

  xdg.userDirs = lib.mkIf isNixOS {
    enable = true;
    createDirectories = true;
  };

  home.packages = lib.optionals (!isNixOS) [
    pkgs.cachix
  ];

  nix = lib.mkIf (!isNixOS) {
    package = pkgs.nix;
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  home.activation.cloneLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #!/usr/bin/env bash
    set -euo pipefail
    NVIM_DOTFILES_DIR="${config.home.homeDirectory}/${repoDir}/home-manager/programs/neovim/config"
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

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}
