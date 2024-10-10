{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  targets.genericLinux.enable = true;

  imports = [
    ./zsh.nix
    ./neovim.nix
    ./devtools.nix
    ./programming-languages.nix
    ./gnome
    ./gui.nix
    ./utils.nix
    ./git.nix
    ./ssh.nix
    ./cli.nix
    ./ulauncher.nix
    ./fonts.nix
    ./dotfiles.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "wezterm";
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.zsh.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
}
