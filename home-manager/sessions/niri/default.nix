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
  ];
  xdg.configFile."niri" = linkFile "sessions/niri/config";
}
