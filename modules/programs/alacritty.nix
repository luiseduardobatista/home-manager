{
  pkgs,
  gl,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = gl pkgs.alacritty;
    settings = {
      general.import = [ "~/.config/alacritty/kanso-zen.toml" ];
      cursor.style.shape = "Block";
      env.TERM = "xterm-256color";
      font.size = 13;
      font.normal.family = "JetBrainsMono Nerd Font";
      mouse.hide_when_typing = true;
      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ];
      window.decorations = "none";
      window.dynamic_padding = false;
      window.padding = {
        x = 0;
        y = 0;
      };
    };
  };
  xdg.configFile."alacritty/kanso-zen.toml".source = ./alacritty/kanso-zen.toml;
}
