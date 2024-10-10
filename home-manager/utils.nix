{
  pkgs,
  config,
  lib,
  ...
}: let
  nixGL = import ./nixGL.nix {inherit pkgs config;};
in {
  home.packages = with pkgs; [
    obsidian
    flameshot
    vlc
    brave
    youtube-music
    tree
  ];
}
