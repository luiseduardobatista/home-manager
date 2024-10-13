{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  ixNixOS,
  ...
}:
# nixGLIntel = inputs.nixGL.packages."${pkgs.system}".nixGLIntel;
{
  targets.genericLinux.enable = true;

  imports = [
     ./zsh.nix
     ./neovim.nix
     ./devtools.nix
     ./programming-languages.nix
     ./gnome/gnome.nix
    # ./gnome/pop-os.nix
    # ./gui.nix
     ./utils.nix
     ./git.nix
     ./ssh.nix
     ./cli.nix
     ./fonts.nix
    # ./hyprland.nix
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "f14874544414b9f6b068cfb8c19d2054825b8531f827ec292c2b0ecc5376b305";
    })
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
