{
  pkgs-unstable,
  linkApp,
  ...
}: {
  programs.zellij.enable = true;
  xdg.configFile."zellij" = linkApp "zellij";
}
