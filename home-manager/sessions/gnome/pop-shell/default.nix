{
  lib,
  pkgs,
  linkApp,
  ...
}: {
  # xdg.configFile."pop-shell/config.json".enable = false;
  xdg.configFile."pop-shell" = linkApp "../sessions/gnome/pop-shell";

  home.packages = with pkgs; [
    gnomeExtensions.pop-shell
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/pop-shell" = {
      toggle-tiling = ["<Super>y"];
      toggle-floating = ["<Super>g"];
      tile-enter = ["<Super>Return"];
      tile-accept = ["Return"];
      tile-reject = ["Escape"];
      toggle-stacking-global = ["<Super>s"];
      pop-workspace-down = [
        "<Shift><Super>Down"
        "<Shift><Super>j"
      ];
      pop-workspace-up = [
        "<Shift><Super>Up"
        "<Shift><Super>k"
      ];
      pop-monitor-left = [
        "<Shift><Super>Left"
        "<Shift><Super>h"
      ];
      pop-monitor-right = [
        "<Shift><Super>Right"
        "<Shift><Super>l"
      ];
      pop-monitor-down = [];
      pop-monitor-up = [];
      focus-left = [
        "<Super>Left"
        "<Super>h"
      ];
      focus-down = [
        "<Super>Down"
        "<Super>j"
      ];
      focus-up = [
        "<Super>Up"
        "<Super>k"
      ];
      focus-right = [
        "<Super>Right"
        "<Super>l"
      ];
      hint-color-rgba = "rgb(90,166,182)";
      smart-gaps = false;
      gap-inner = lib.hm.gvariant.mkUint32 1;
      gap-outer = lib.hm.gvariant.mkUint32 1;
      active-hint = true;
      active-hint-border-radius = lib.hm.gvariant.mkUint32 4;
      mouse-cursor-focus-location = lib.hm.gvariant.mkUint32 4;
    };
  };
}
