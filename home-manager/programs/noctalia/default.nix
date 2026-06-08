{
  pkgs-unstable,
  lib,
  config,
  linkApp,
  ...
}: {
  programs.noctalia = {
    enable = true;
  };
  xdg.configFile."noctalia" = linkApp "noctalia";
}
