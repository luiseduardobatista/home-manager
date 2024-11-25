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
  home.packages = with pkgs;
    [
      (nixGLwrap obsidian)
      flameshot
      vlc
      youtube-music
      tree
    ]
    ++ (
      if isNixOS
      then [
        brave
      ]
      else []
    );
}
