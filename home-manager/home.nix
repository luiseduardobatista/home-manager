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
      ./gnome/gnome.nix
      ./configs/git.nix
      ./configs/ssh.nix
      ./packages.nix
    ]
    ++ (
      if isNixOS
      then [
        ./zsh.nix
      ]
      else []
    );

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      NIXOS_OZONE_WL = 1;
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.zsh.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
}
