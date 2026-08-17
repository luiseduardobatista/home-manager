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
      };
      key-bindings.fullscreen = "F11";
      mouse.hide-when-typing = "yes";
      cursor.style = "block";
      csd.preferred = "none";
      colors-dark = {
        foreground = "c5c9c7";
        background = "090e13";
        regular0 = "090e13";
        regular1 = "c4746e";
        regular2 = "8a9a7b";
        regular3 = "c4b28a";
        regular4 = "8ba4b0";
        regular5 = "a292a3";
        regular6 = "8ea4a2";
        regular7 = "a4a7a4";
        bright0 = "5c6066";
        bright1 = "e46876";
        bright2 = "87a987";
        bright3 = "e6c384";
        bright4 = "7fb4ca";
        bright5 = "938aa9";
        bright6 = "7aa89f";
        bright7 = "c5c9c7";
        "16" = "b6927b";
        "17" = "b98d7b";
        selection-foreground = "c5c9c7";
        selection-background = "22262d";
        urls = "72a7bc";
      };
    };
  };
}
