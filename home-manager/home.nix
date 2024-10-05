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
    ./terminal.nix
    ./programming-languages.nix
    ./gnome
    ./gui.nix
    ./utils.nix
    ./git.nix
  ];

  #nixGLPrefix = "${pkgs.nixGL.packages.x86_64-linux.nixGLDefault}/bin/nixGLDefault";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "luisb";
    homeDirectory = "/home/luisb";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
