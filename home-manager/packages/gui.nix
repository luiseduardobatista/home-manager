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

  nixOSPackages = with pkgs;
    if isNixOS
    then [
      wezterm
      kitty
      alacritty
      brave
      flameshot
    ]
    else [];
in {
  home.packages = with pkgs;
    [
      (nixGLwrap jetbrains-toolbox)
      (nixGLwrap vscode)
      (nixGLwrap dbeaver-bin)
      (nixGLwrap bruno)
      (nixGLwrap remmina)
      gearlever
    ]
    ++ nixOSPackages;
}
