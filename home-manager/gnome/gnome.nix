{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./pop-shell-config.nix
    ./shared.nix
    # ../ulauncher.nix
  ];

  home.packages = with pkgs-unstable; [
    # Default
    bibata-cursors
    wmctrl

    # Extensions
    gnomeExtensions.pop-shell
    gnomeExtensions.forge
    gnomeExtensions.dash-to-dock
    gnomeExtensions.vitals
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.astra-monitor
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.space-bar
  ] ;

  dconf.settings = {
    # Enable Extensions
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "pop-shell@system76.com"
        # "forge@jmmaranan.com"
        # "dash-to-dock@micxgx.gmail.com"
        "vitals@CoreCoding.com"
        # "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        # "monitor@astraext.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "space-bar@luchrioh"
        "bluetooth-quick-connect@bjarosze.gmail.com"
      ];
    };

    # Gnome
    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "${config.home.sessionVariables.TERMINAL}";
      name = "Launch Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    # "org/gnome/shell" = {
    #   favorite-apps = [
    #     "brave-browser.desktop"
    #     "org.wezfurlong.wezterm.desktop"
    #     "org.gnome.Nautilus.desktop"
    #     "dbeaver.desktop"
    #     "obsidian.desktop"
    #   ];
    # };

    # Window management keybinds
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

    "org/gnome/shell/extensions/forge" = {
      stacked-tiling-mode-enabled = false;
      tiling-mode-enabled = true;
      window-gap-hidden-on-single = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = ["<Super>Escape"];
      home = ["<Super>f"];
      www = ["<Super>b"];
      email = ["<Super>e"];
      rotate-video-lock-static = [];
    };

    # Blur My Shell
    "org/gnome/shell/extensions/blur-my-shell" = {
      "dash-to-dock/blur" = false;
    };

    # Dash to Dock
    "org/gnome/shell/extensions/dash-to-dock" = {
      click-action = "focus-minimize-or-previews";
      custom-theme-shrink = true;
      dock-fixed = false;
      dock-position = "BOTTOM";
      hot-keys = false;
      intellihide-mode = "ALL_WINDOWS";
      running-indicator-style = "DOTS";
      show-show-apps-button = false;
      show-trash = false;
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

    # AppIndicator and KStatusNotifierItem Support
    "org/gnome/shell/extensions/appindicator" = {
      icon-opacity = 220;
      icon-saturation = 0;
      icon-size = 20;
      legacy-tray-enabled = true;
    };
  };
}
