{
  pkgs-unstable,
  lib,
  config,
  linkFile,
  ...
}: {
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;
  };

  xdg.configFile."opencode/opencode.json" = linkFile "programs/opencode/config/opencode.json";
}
