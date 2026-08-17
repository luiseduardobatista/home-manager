{config, ...}: {
  flake.modules.homeManager.luis = {
    lib,
    pkgs,
    nixGL,
    isNixOS,
    substituters,
    trustedPublicKeys,
    ...
  }: {
    imports = with config.flake.modules.homeManager; [
      gnome
      niri
      fonts
      onepassword
      alacritty
      cli
      zoxide
      flameshot
      foot
      ghostty
      git
      kitty
      mise
      neovim
      ssh
      tmux
      wezterm
      whisper
      flatpak
      jetbrains-toolbox
      ideavim
      dev-langs
      helix
      noctalia
      zed
      zellij
      opencode
      pi
      fish
      zsh
      starship
    ];

    targets.genericLinux.enable = !isNixOS;
    targets.genericLinux.nixGL.packages = lib.mkIf (!isNixOS) nixGL.packages;

    home = {
      username = "luisb";
      homeDirectory = "/home/luisb";
      sessionVariables = {
        BROWSER = "firefox";
        TERMINAL = "foot";
        NIXOS_OZONE_WL = 1;
        # decibri (rpiv-voice) precisa de libasound.so.2, que no NixOS não está
        # no caminho padrão do loader (binários pré-compilados não acham a lib).
        LD_LIBRARY_PATH = "${pkgs.alsa-lib}/lib";
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
        inherit substituters;
        trusted-public-keys = trustedPublicKeys;
      };
    };

    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
    home.stateVersion = "26.05";
  };
}
