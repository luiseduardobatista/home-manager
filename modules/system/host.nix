{
  config,
  ...
}: {
  flake.modules.nixos.host = {
    pkgs,
    inputs,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      locale
      nix
      ssh
    ];

    users.users.luisb = {
      isNormalUser = true;
      description = "Luís Eduardo Batista";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "video"
        "audio"
        "input"
      ];
      packages = with pkgs; [
        #  thunderbird
      ];
    };

    system.stateVersion = "25.11"; # Did you read the comment?

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.firefox.enable = true;

    programs.fish.enable = true;
    programs.starship.enable = true;
    users.defaultUserShell = pkgs.fish;

    services.flatpak.enable = true;

    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = ["luisb"];
    };

    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      curl
      tree
      fish
      cachix
      inetutils
      usbutils
      wl-clipboard
      xclip
      inputs.whisper.packages.${pkgs.system}.default
      brave
      v4l-utils
      libreoffice
      cmake
    ];
  };
}
