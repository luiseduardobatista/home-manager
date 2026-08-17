{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.host-laptop = {
    imports = with config.flake.modules.nixos; [
      desktop
      docker
      ./laptop/hardware-configuration.nix
    ];

    networking.hostName = "laptop";
    hardware.graphics.enable = true;
    services.power-profiles-daemon.enable = false;
    services.tlp.enable = true;
    services.fprintd.enable = true;
    services.xserver.xkb = {
      layout = "us,br";
      variant = "alt-intl,";
      options = lib.mkForce "";
    };
  };

  flake.modules.homeManager.host-laptop = {lib, ...}: {
    imports = with config.flake.modules.homeManager; [
      luis
    ];

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        sources = lib.mkForce [
          (lib.gvariant.mkTuple ["xkb" "us+alt-intl"])
          (lib.gvariant.mkTuple ["xkb" "br"])
        ];
        mru-sources = lib.mkForce [
          (lib.gvariant.mkTuple ["xkb" "br"])
          (lib.gvariant.mkTuple ["xkb" "us+alt-intl"])
        ];
        xkb-options = [];
      };
    };
  };
}
