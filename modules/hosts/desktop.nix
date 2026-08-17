{config, ...}: {
  flake.modules.nixos.host-desktop = {
    imports = with config.flake.modules.nixos; [
      desktop
      docker
      ./desktop/hardware-configuration.nix
      ./desktop/gaming.nix
    ];

    networking.hostName = "desktop";
  };

  flake.modules.homeManager.host-desktop = {
    imports = with config.flake.modules.homeManager; [
      luis
    ];
  };
}
