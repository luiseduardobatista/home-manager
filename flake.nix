{
  description = "My flake config";

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
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations = {
      "luisb" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit outputs;
          isNixOS = false;
          inherit nixGL;
          inherit nix-flatpak;
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
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hosts/desktop/configuration.nix
          ./nixos/common.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit inputs outputs;
              inherit nixGL;
              inherit nix-flatpak;
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

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
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
