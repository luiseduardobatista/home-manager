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
    quickshell
    xwayland-satellite
  ];
  xdg.configFile."niri" = linkFile "sessions/niri/config";
}
