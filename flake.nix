{
  description = "My flake config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:luiseduardobatista/lazyvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixGL,
    ...
  } @ inputs: let
    inherit (self) outputs;
    hostname = "nixos";
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
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
