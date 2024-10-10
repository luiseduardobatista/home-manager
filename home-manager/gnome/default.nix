{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./pop-shell-config.nix
  ];

  home.packages = with pkgs; [
    # Default
    bibata-cursors
    wmctrl

    # Extensions
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    gnomeExtensions.space-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.astra-monitor

    # Utils
    gnome.dconf-editor
    gnome-extensions-cli # Para pegar os nome completo da extensão
    gnome.sushi
    gnome.gnome-tweaks

    # Themes
    tokyonight-gtk-theme
  ];

  dconf.settings = {
    # Enable Extensions
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
        "vitals@CoreCoding.com"
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "space-bar@luchrioh"
        "just-perfection-desktop@just-perfection"
        "monitor@astraext.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
      ];
    };

    # Gnome
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      center-new-windows = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };

    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "${config.home.sessionVariables.TERMINAL}";
      name = "Launch Terminal";
    };

    #Pop Shell bindings
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q" "<Alt>F4"];
      minimize = ["<Super>comma"];
      toggle-maximized = ["<Super>m"];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-monitor-down = [];
      move-to-workspace-down = [];
      move-to-workspace-up = [];
      switch-to-workspace-down = ["<Primary><Super>Down"];
      switch-to-workspace-up = ["<Primary><Super>Up"];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
      maximize = [];
      unmaximize = [];
    };

    "org/gnome/shell/keybindings" = {
      open-application-menu = [];
      toggle-message-tray = ["<Super>v"];
      toggle-overview = [];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      toggle-tiling = ["<Super>y"];
      toggle-floating = ["<Super>g"];
      tile-enter = ["<Super>Return"];
      tile-accept = ["Return"];
      tile-reject = ["Escape"];
      toggle-stacking-global = ["<Super>s"];
      pop-workspace-down = ["<Shift><Super>Down" "<Shift><Super>j"];
      pop-workspace-up = ["<Shift><Super>Up" "<Shift><Super>k"];
      pop-monitor-left = ["<Shift><Super>Left" "<Shift><Super>h"];
      pop-monitor-right = ["<Shift><Super>Right" "<Shift><Super>l"];
      pop-monitor-down = [];
      pop-monitor-up = [];
      focus-left = ["<Super>Left" "<Super>h"];
      focus-down = ["<Super>Down" "<Super>j"];
      focus-up = ["<Super>Up" "<Super>k"];
      focus-right = ["<Super>Right" "<Super>l"];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = ["<Super>Escape"];
      home = ["<Super>f"];
      www = ["<Super>b"];
      email = ["<Super>e"];
      rotate-video-lock-static = [];
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

    # Blur My Shell
    "org/gnome/shell/extensions/blur-my-shell" = {
      "dash-to-dock/blur" = false;
    };

    # Dash to Dock
    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
    };

    # Space Bar
    "org/gnome/shell/extensions/space-bar/behavior" = {
      "smart-workspace-names" = false;
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      "enable-activate-workspace-shortcuts" = false;
      "enable-move-to-workspace-shortcuts" = true;
      "open-menu" = "@as []";
    };

    # Just Perfection
    "org/gnome/shell/extensions/just-perfection" = {
      animation = 1;
      dash-app-running = true;
      workspace = true;
      workspace-popup = false;
    };

    # Alphabetical App Grid
    "org/gnome/shell/extensions/alphabetical-app-grid" = {
      folder-order-position = "end";
    };
  };
}
