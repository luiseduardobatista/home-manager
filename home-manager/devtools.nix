{
  pkgs,
  config,
  isNixOS,
  pkgs-unstable,
  ...
}: let
  nixGLwrap = pkg:
    if isNixOS
    then pkg
    else config.lib.nixGL.wrap pkg;
in {
  home.packages = with pkgs;
    [
      (nixGLwrap jetbrains-toolbox)
      (nixGLwrap vscode)
      (nixGLwrap dbeaver-bin)
      (nixGLwrap insomnia)
      (nixGLwrap remmina)
      gnumake
      unzip
      poetry
      openfortivpn
      golines
      stow
      nodePackages.localtunnel

      ## AWS
      aws-sam-cli
      awscli
    ]
    ++ (
      if isNixOS
      then [
        wezterm
        alacritty
      ]
      else []
    );
}
