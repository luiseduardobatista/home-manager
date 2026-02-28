{
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
  };
}
