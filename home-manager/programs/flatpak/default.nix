{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.flatpak = {
    enable = true;

    overrides = {
      global = {
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
        Environment = {
          "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
          "NIXOS_OZONE_WL" = "1";
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
    };

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      "org.flameshot.Flameshot"
      "com.usebruno.Bruno"
      "org.remmina.Remmina"
      "it.mijorus.gearlever"
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
      "io.dbeaver.DBeaverCommunity"
      "com.github.wwmm.easyeffects"
      "org.telegram.desktop"
      "com.getpostman.Postman"
      "com.obsproject.Studio"
      "hu.irl.cameractrls"
    ];
  };
}
