{
  flake.modules.nixos.v4l2loopback = {
    config,
    ...
  }: {
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.kernelModules = ["v4l2loopback"];
  };
}
