{
  description = "My flake config";
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://pi.cachix.org"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:luiseduardobatista/lazyvim";
      flake = false;
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/v4.7.7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pi.url = "github:lukasl-dev/pi.nix";
    zesh = {
      url = "github:roberte777/zesh";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixGL,
    nix-flatpak,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    repoDir = "nix";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    sharedArgs = {
      inherit
        inputs
        outputs
        nixGL
        nix-flatpak
        repoDir
        pkgs-unstable
        ;
    };
    homeManagerUserConfig = {
      imports = [
        ./home-manager/home.nix
        nix-flatpak.homeManagerModules.nix-flatpak
      ];
    };
    mkNixos = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = sharedArgs;
        modules = [
          ./nixos/hosts/${hostName}/configuration.nix
          ./nixos/common.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs =
                sharedArgs
                // {
                  isNixOS = true;
                };
              users.luisb = homeManagerUserConfig;
            };
          }
        ];
      };
  in {
    homeConfigurations = {
      "luisb" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs =
          sharedArgs
          // {
            isNixOS = false;
          };
        modules = [homeManagerUserConfig];
      };
    };
    nixosConfigurations = {
      desktop = mkNixos "desktop";
      laptop = mkNixos "laptop";
    };
  };
}
