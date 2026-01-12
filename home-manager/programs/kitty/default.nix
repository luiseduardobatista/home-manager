{
  pkgs,
  linkApp,
  gl,
  ...
}:
{
  programs.kitty = {
    enable = true;
    package = gl pkgs.kitty;
  };
  xdg.configFile."kitty" = linkApp "kitty";
}
