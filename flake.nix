{
  description = "My flake config";
  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    nix-flatpak.url = "github:gmodena/nix-flatpak/";
  };
  outputs = {
    self,
    nixpkgs,
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
    sharedArgs = {
      inherit
        inputs
        outputs
        nixGL
        nix-flatpak
        repoDir
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
