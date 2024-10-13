{
  pkgs,
  config,
  isNixOS,
  ...
}: let
  nixGLwrap = pkg:
    if isNixOS
    then pkg
    else config.lib.nixGL.wrap pkg;
in {
  home.packages = with pkgs; [
    (nixGLwrap obsidian)
    flameshot
    vlc
    (nixGLwrap brave)
    youtube-music
    tree
  ];
}
