{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "desktop";

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
