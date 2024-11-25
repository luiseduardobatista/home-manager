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
    gnomeExtensions.sound-output-device-chooser
  ];

  dconf.settings = {
    # Enable Extensions
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "sound-output-device-chooser@kgshank.net"
      ];
    };

    # Sound Output Device Chooser
    "org/gnome/shell/extensions/sound-output-device-chooser" = {
      expand-volume-menu = false;
      integrate-with-slider = true;
      show-profiles = false;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      intellihide = false;
      extend-height = false;
      show-profiles = false;
      show-mounts = false;
      show-mounts-network = false;
      show-show-apps-button = false;
      show-trash = false;
      click-action = "minimize-or-previews";
    };
  };
}
