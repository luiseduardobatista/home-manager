{
  inputs,
  pkgs,
  config,
  linkApp,
  ...
}: {
  programs.dank-material-shell = {
    enable = true;
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    systemd = {
      enable = false;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };
  # xdg.configFile."noctalia" = linkApp "noctalia";
}
