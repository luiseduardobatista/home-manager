{
  description = "My flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixGL.url = "github:guibou/nixGL";
    flatpaks.url = "github:gmodena/nix-flatpak/main";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixGL,
    flatpaks,
    ...
  } @ inputs: let
    inherit (self) outputs;
    hostname = "nixos";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
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
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          flatpaks.homeManagerModules.nix-flatpak
          (
            {...}: {
              config.nixGLPrefix = "${nixGL.packages.x86_64-linux.nixGLIntel}/bin/nixGLIntel ";
            }
          )
        ];
        extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit flatpaks;
          };
      };
    };
  };
}
