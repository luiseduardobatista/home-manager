{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
    ../../desktops/niri.nix
  ];

  networking.hostName = "desktop";

  home-manager.users.luisb = {
    my.desktop.niri.enable = true;
    my.desktop.gnome.enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
}
