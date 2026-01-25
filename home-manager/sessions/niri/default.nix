{
  config,
  lib,
  pkgs,
  isNixOS,
  ...
}: {
  home.packages = with pkgs; [
    fuzzel
    quickshell
  ];
}
