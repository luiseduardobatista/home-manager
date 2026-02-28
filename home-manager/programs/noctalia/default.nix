{
  inputs,
  pkgs-unstable,
  lib,
  config,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  config = lib.mkIf config.my.desktop.niri.enable {
    programs.noctalia-shell = {
      enable = true;
    };
  };
}
