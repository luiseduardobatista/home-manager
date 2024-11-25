{
  description = "My flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixGL.url = "github:guibou/nixGL";
    #TODO: Remover quando o mr for mergeado no home-manager
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixGL,
    ...
  } @ inputs: let
    inherit (self) outputs;
    hostname = "nixos";
    system = "x86_64-linux";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      ${hostname} = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/configuration.nix];
      };
    };

    homeConfigurations = {
      "luisb" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          inherit outputs;
          isNixOS = false;
          inherit pkgs-unstable;
        };
        modules = [
          ./home-manager/home.nix
          (
            {...}: {
              # config.nixGLPrefix = "${nixGL.packages.x86_64-linux.nixGLIntel}/bin/nixGLIntel ";
            }
          )
        ];
      };
    };
  };
}
