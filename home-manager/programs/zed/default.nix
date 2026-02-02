{
  pkgs-unstable,
  linkApp,
  ...
}: {
  home.packages = with pkgs-unstable; [
    zed-editor-fhs
  ];

  xdg.configFile."zed" = linkApp "zed";
}
