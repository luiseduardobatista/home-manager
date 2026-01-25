{
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  programs.noctalia-shell = {
    enable = true;
  };
}
