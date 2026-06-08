{
  pkgs-unstable,
  lib,
  config,
  linkApp,
  ...
}: {
  programs.noctalia-shell = {
    enable = true;
  };
  xdg.configFile."noctalia" = linkApp "noctalia";
}
