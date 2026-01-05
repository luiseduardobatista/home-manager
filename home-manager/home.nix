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
  targets.genericLinux.enable = !isNixOS;
  targets.genericLinux.nixGL.packages = lib.mkIf (!isNixOS) nixGL.packages;

  imports = [
    ./desktop/gnome/gnome.nix # Desabilite para o build em Docker
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/fish.nix
    ./programs/autostart.nix
    ./programs/distrobox.nix
    ./packages/main.nix
    ./dotfiles/main.nix
  ]
  ++ lib.optionals isNixOS [
    ./programs/zsh.nix
  ];

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      EDITOR = "nvim";
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

  _module.args.gl = config.lib.nixGL.wrap;

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

  home.activation.setupDistrobox = lib.mkIf isNixOS (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ini_file="${config.xdg.configHome}/distrobox/distrobox.ini"

      if [ -f "${pkgs.distrobox}/bin/distrobox" ] && [ -f "$ini_file" ]; then
        echo "📦 Processando manifesto do Distrobox..."
        
        export PATH=$PATH:${
          lib.makeBinPath [
            pkgs.docker
            pkgs.distrobox
            pkgs.git
            pkgs.coreutils
          ]
        }
        
        ${pkgs.distrobox}/bin/distrobox assemble create --file "$ini_file"
      else
        echo "⚠️ Distrobox ou arquivo .ini não encontrados. Pulando automação."
      fi
    ''
  );

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";

}
