{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.user-themes
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.sound-output-device-chooser

    # Utils
    gnome.dconf-editor
    gnome-extensions-cli # Para pegar os nome completo da extensão
    gnome.sushi
    gnome.gnome-tweaks
  ];

  programs.gnome.wallpaper = {
    file = "./background.png";
  };

  dconf.settings = {
    # Enable Extensions
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "sound-output-device-chooser@kgshank.net"
      ];
    };

    # Gnome
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      center-new-windows = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 8;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
      move-to-workspace-7 = ["<Super><Shift>7"];
      move-to-workspace-8 = ["<Super><Shift>8"];
      move-to-workspace-9 = ["<Super><Shift>9"];

      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-8 = ["<Super>8"];
      switch-to-workspace-9 = ["<Super>9"];
    };
  };
}
