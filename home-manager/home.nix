{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  ixNixOS,
  ...
}: {
  targets.genericLinux.enable = true;
  nixGL.packages = nixGL.packages;

  imports = [
    ./zsh.nix
    ./neovim.nix
    ./devtools.nix
    ./programming-languages.nix
    ./gnome/gnome.nix
    # ./gnome/pop-os.nix
    ./utils.nix
    ./git.nix
    ./ssh.nix
    ./cli.nix
    ./fonts.nix
  ];

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
  programs.git.enable = true;
  programs.zsh.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";
}
