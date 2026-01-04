{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "laptop";
  hardware.graphics.enable = true;
  services.tlp.enable = true;
}
