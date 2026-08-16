{
  flake.modules.nixos.v4l2loopback = {
    config,
    pkgs,
    ...
  }: {
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.kernelModules = ["v4l2loopback"];
    environment.systemPackages = [pkgs.v4l-utils];
  };
}
