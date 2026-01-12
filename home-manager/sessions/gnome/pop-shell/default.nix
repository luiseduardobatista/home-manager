{
  lib,
  pkgs,
  ...
}: {
  imports = [];
  home.packages = with pkgs; [
    # Extensions
    gnomeExtensions.pop-shell
  ];
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
  dconf.settings = [
    {
      "org/gnome/shell" = {
        "enabled-extensions" = [
          "pop-shell@system76.com"
        ];
      };
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
    }
  ];
}
