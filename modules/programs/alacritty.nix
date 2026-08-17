{
  pkgs,
  gl,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = gl pkgs.alacritty;
    settings = {
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
      window = {
        decorations = "none";
        dynamic_padding = false;
        padding = {
          x = 0;
          y = 0;
        };
      };
      colors = {
        primary = {
          background = "#090e13";
          foreground = "#c5c9c7";
        };
        selection = {
          text = "#c5c9c7";
          background = "#22262d";
        };
        normal = {
          black = "#090e13";
          red = "#c4746e";
          green = "#8a9a7b";
          yellow = "#c4b28a";
          blue = "#8ba4b0";
          magenta = "#a292a3";
          cyan = "#8ea4a2";
          white = "#a4a7a4";
        };
        bright = {
          black = "#5c6066";
          red = "#e46876";
          green = "#87a987";
          yellow = "#e6c384";
          blue = "#7fb4ca";
          magenta = "#938aa9";
          cyan = "#7aa89f";
          white = "#c5c9c7";
        };
        indexed_colors = [
          {
            index = 16;
            color = "#b6927b";
          }
          {
            index = 17;
            color = "#b98d7b";
          }
        ];
      };
    };
  };
}
