{
  pkgs,
  linkApp,
  gl,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = gl pkgs.wezterm;
  };
  xdg.configFile."wezterm" = linkApp "wezterm";
}
