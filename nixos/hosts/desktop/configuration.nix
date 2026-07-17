{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
  ];
  networking.hostName = "desktop";
}
