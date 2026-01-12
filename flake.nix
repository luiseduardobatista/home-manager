{
  description = "My flake config";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixGL,
      nix-flatpak,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      repoDir = "nix";
    in
    {
      homeConfigurations = {
        "luisb" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit outputs;
            inherit nixGL;
            inherit nix-flatpak;
            inherit repoDir;
            isNixOS = false;
          };
          modules = [
            nix-flatpak.homeManagerModules.nix-flatpak
            ./home-manager/home.nix
          ];
        };
      };

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/hosts/desktop/configuration.nix
            ./nixos/common.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";

                extraSpecialArgs = {
                  inherit inputs outputs;
                  inherit nixGL;
                  inherit nix-flatpak;
                  inherit repoDir;
                  isNixOS = true;
                };
                users.luisb = {
                  imports = [
                    ./home-manager/home.nix
                    nix-flatpak.homeManagerModules.nix-flatpak
                  ];
                };
              };
            }
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          inherit repoDir;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/hosts/laptop/configuration.nix
            ./nixos/common.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
                inherit nixGL;
                inherit nix-flatpak;
                inherit repoDir;
                isNixOS = true;
              };

              home-manager.users.luisb = {
                imports = [
                  ./home-manager/home.nix
                  nix-flatpak.homeManagerModules.nix-flatpak
                ];
              };
            }
          ];
        };
      };
    };
}
