{
  pkgs,
  linkApp,
  gl,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = gl pkgs.alacritty;
  };
  xdg.configFile."alacritty" = linkApp "alacritty";
}
