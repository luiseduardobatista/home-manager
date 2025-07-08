{ pkgs, config, isNixOS, pkgs-unstable, ... }:
let
  nixGLwrap = pkg:
    if isNixOS
    then pkg
    else config.lib.nixGL.wrap pkg;

  nixOSPackages = with pkgs-unstable;
    if isNixOS
    then [
      wezterm
      kitty
      alacritty
      brave
      flameshot
    ]
    else [];
in
{
  home.packages = with pkgs-unstable; [
    (nixGLwrap jetbrains-toolbox)
    (nixGLwrap vscode)
    (nixGLwrap dbeaver-bin)
    (nixGLwrap bruno)
    (nixGLwrap remmina)
    gearlever
  ] ++ nixOSPackages;
}
