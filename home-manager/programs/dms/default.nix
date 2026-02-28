{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [inputs.dms.homeModules.dank-material-shell];

  config = lib.mkIf config.my.desktop.niri.enable {
    programs.dank-material-shell = {
      enable = true;
      dgop.package = inputs.dgop.packages.${pkgs.system}.default;
      systemd = {
        enable = false;
      };
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };
  };
}
