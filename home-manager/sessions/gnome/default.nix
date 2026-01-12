{
  config,
  lib,
  pkgs,
  isNixOS,
  ...
}: {
  imports = [
    ./pop-shell
  ];

  options.programs.gnome = {
    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Lista de extensões do GNOME para ativar automaticamente.";
    };
  };

  # IMPORTANTE: Algumas configurações do GNOME no Home Manager precisam de tipos explícitos
  # para funcionarem corretamente. Use lib.hm.gvariant quando as configurações não
  # estiverem sendo aplicadas:
  #
  # - Inteiros: lib.hm.gvariant.mkUint32 valor
  # - Strings: lib.hm.gvariant.mkString "valor"
  # - Booleanos: lib.hm.gvariant.mkBoolean true
  # - Arrays: lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["item1" "item2"]
  #
  # Exemplo: gap-inner, gap-outer e active-hint-border-radius do Pop Shell
  # precisam ser definidos como mkUint32 para funcionarem.

  config = {
    home.packages = with pkgs; [
      # Default
      bibata-cursors
      wmctrl

      # Extensions
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
      gnomeExtensions.disable-workspace-animation
      gnomeExtensions.search-light
      gnomeExtensions.window-is-ready-remover

      dconf-editor
      sushi
      gnome-tweaks
      gnome-extensions-cli # Para pegar os nome completo da extensão
    ];

    dconf.settings = lib.mkMerge [
      (lib.mkIf isNixOS {
        "org/gnome/desktop/input-sources" = {
          sources = [
            (lib.hm.gvariant.mkTuple [
              "xkb"
              "us+alt-intl"
            ])
          ];
        };
      })

      {
        "org/gnome/shell" = {
          "enabled-extensions" =
            config.programs.gnome.extensions
            ++ [
              # Cole aqui a lista de extensões que você já tinha:
              "pop-shell@system76.com"
              "vitals@CoreCoding.com"
              "just-perfection-desktop@just-perfection"
              "AlphabeticalAppGrid@stuarthayhurst"
              "appindicatorsupport@rgcjonas.gmail.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "space-bar@luchrioh"
              "bluetooth-quick-connect@bjarosze.gmail.com"
              "disable-workspace-animation@ethnarque"
              "search-light@icedman.github.com"
              "clipboard-indicator@tudmotu.com"
            ];
        };

        "org/gnome/desktop/calendar" = {
          "show-weekdate" = true;
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          center-new-windows = true;
          edge-tiling = true;
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 9;
        };

        "org/gnome/desktop/interface" = {
          enable-hot-corners = false;
          color-scheme = "prefer-dark";
        };

        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
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
          screensaver = ["<Super>Escape"];
          home = ["<Super>f"];
          www = ["<Super>b"];
          email = ["<Super>e"];
          rotate-video-lock-static = [];
        };

        "org/gnome/desktop/wm/keybindings" = {
          close = [
            "<Super>q"
            "<Alt>F4"
          ];
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
          switch-windows = ["<Alt>Tab"];
          switch-applications = ["<Super>Tab"];
        };

        "org/gnome/shell/keybindings" = {
          open-application-menu = [];
          toggle-message-tray = ["<Super>v"];
          toggle-overview = [];
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

        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left = [];
          toggle-tiled-right = [];
        };

        "org/gnome/mutter/wayland/keybindings" = {
          restore-shortcuts = [];
        };

        "org/gnome/shell/extensions/forge" = {
          stacked-tiling-mode-enabled = false;
          tiling-mode-enabled = true;
          window-gap-hidden-on-single = false;
          auto-split-enabled = true;

          focus-border-toggle = true;
          focus-on-hover-enabled = false;
          move-pointer-focus-enabled = true;
          preview-hint-enabled = true;
          quick-settings-enabled = true;
          split-border-toggle = true;
          window-gap-size = 4;
          window-gap-size-increment = 1;
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

        # Search Light
        "org/gnome/shell/extensions/search-light" = {
          animation-speed = 50;
          popup-at-cursor-monitor = true;
          preferred-monitor = 0;
          shortcut-search = ["<Super>d"];
        };

        "org/gnome/shell/extensions/space-bar/behavior" = {
          smart-workspace-names = false;
          toggle-overview = false;
          show-empty-workspaces = false;
        };

        "org/gnome/shell/extensions/space-bar/shortcuts" = {
          enable-activate-workspace-shortcuts = false;
          enable-move-to-workspace-shortcuts = true;
          open-menu = "@as []";
        };
      }
    ];
  };
}
