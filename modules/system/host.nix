{config, ...}: {
  flake.modules.nixos.host = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      locale
      nix
      ssh
      boot
      networking
      nix-ld
    ];

    users.users.luisb = {
      isNormalUser = true;
      description = "Luís Eduardo Batista";
      extraGroups = [
        "wheel"
        "video"
        "input"
      ];
      packages = with pkgs; [
        #  thunderbird
      ];
    };

    system.stateVersion = "25.11"; # Did you read the comment?

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };

      fish.enable = true;
      starship.enable = true;
      _1password.enable = true;
    };

    users.defaultUserShell = pkgs.fish;

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
      cmake
    ];
  };
}
