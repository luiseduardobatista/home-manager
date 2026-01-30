{
  pkgs-unstable,
  linkApp,
  ...
}: {
  home.packages = with pkgs-unstable; [
    zed-editor
  ];

  xdg.configFile."zed" = linkApp "zed";
}
