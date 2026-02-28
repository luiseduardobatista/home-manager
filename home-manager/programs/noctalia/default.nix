{
  inputs,
  pkgs-unstable,
  lib,
  config,
  linkApp,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  config = lib.mkIf config.my.desktop.niri.enable {
    programs.noctalia-shell = {
      enable = true;
    };
    xdg.configFile."noctalia" = linkApp "noctalia";
  };
}
