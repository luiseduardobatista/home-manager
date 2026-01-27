{
  config,
  lib,
  pkgs,
  isNixOS,
  linkFile,
  ...
}: {
  home.packages = with pkgs; [
    fuzzel
    xwayland-satellite
  ];
  xdg.configFile."niri" = linkFile "sessions/niri/config";
}
