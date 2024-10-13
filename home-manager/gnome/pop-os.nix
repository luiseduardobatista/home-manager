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
  };
}
