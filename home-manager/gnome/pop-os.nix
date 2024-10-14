{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./shared.nix
  ];

  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.sound-output-device-chooser
  ];

  dconf.settings = {
    # Enable Extensions
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "sound-output-device-chooser@kgshank.net"
      ];
    };

    # Sound Output Device Chooser
    "org/gnome/shell/extensions/sound-output-device-chooser" = {
      expand-volume-menu = false;
      integrate-with-slider = true;
      show-profiles = false;
    };
  };
}
