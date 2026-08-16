{
  config,
  ...
}: {
  flake.modules.nixos.host-desktop = {
    imports = with config.flake.modules.nixos; [
      desktop
      boot
      networking
      docker
      nix-ld
      v4l2loopback
      gnome
      niri
      ./desktop/hardware-configuration.nix
      ./desktop/gaming.nix
    ];

    networking.hostName = "desktop";
  };
}
