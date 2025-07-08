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
}
