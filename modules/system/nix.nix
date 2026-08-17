{
  flake.modules.nixos.nix = {
    substituters,
    trustedPublicKeys,
    ...
  }: {
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
      inherit substituters;
      trusted-public-keys = trustedPublicKeys;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}
