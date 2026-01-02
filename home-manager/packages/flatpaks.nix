{
  inputs,
  lib,
  config,
  pkgs,
  nixGL,
  ...
}:
{
  targets.genericLinux.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.flameshot.Flameshot"
    "com.usebruno.Bruno"
    "org.remmina.Remmina"
    "it.mijorus.gearlever"
    "app.zen_browser.zen"
    "com.github.tchx84.Flatseal"
    "io.dbeaver.DBeaverCommunity"
    "com.github.wwmm.easyeffects"
    "org.telegram.desktop"
  ];
}
