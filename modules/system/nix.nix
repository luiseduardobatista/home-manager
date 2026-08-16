{
  flake.modules.nixos.nix = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };

    # Enable flakes and Cachix
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://pi.cachix.org"
        "https://noctalia.cachix.org"
        "https://luiseduardobatista.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "luiseduardobatista.cachix.org-1:n72Rp2wotqSy5rQ0un3RnBbWiptb9zVfGAqU8f1xqL0="
      ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
