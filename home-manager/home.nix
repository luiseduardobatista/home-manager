{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  nixGL,
  isNixOS,
  repoDir,
  ...
}: {
  targets.genericLinux.enable = !isNixOS;
  targets.genericLinux.nixGL.packages = lib.mkIf (!isNixOS) nixGL.packages;

  imports = [
    inputs.noctalia.homeModules.default
    # inputs.dms.homeModules.dank-material-shell
    ./lib/helpers.nix
    ./sessions
    ./theming
    ./programs
    ./shells
  ];

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      NIXOS_OZONE_WL = 1;
    };
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

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}
