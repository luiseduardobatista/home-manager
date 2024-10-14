{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.nvidia;
in {
  options.services.nvidia.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable NVIDIA settings.";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;
    boot.kernelParams = ["nvidia_drm.fbdev=1"];
  };
}
