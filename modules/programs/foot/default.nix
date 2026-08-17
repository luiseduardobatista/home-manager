{
  pkgs,
  gl,
  ...
}: {
  programs.foot = {
    enable = true;
    package = gl pkgs.foot;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=13";
        pad = "0x0";
        resize-by-cells = "no";
        term = "xterm-256color";
        include = "~/.config/foot/themes/kanso-zen.ini";
      };
      key-bindings.fullscreen = "F11";
      mouse.hide-when-typing = "yes";
      cursor.style = "block";
      csd.preferred = "none";
    };
  };
  xdg.configFile."foot/themes/kanso-zen.ini".source = ./themes/kanso-zen.ini;
}
