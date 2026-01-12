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
    settings = { };
  };
  xdg.configFile."kitty/kitty.conf".enable = false;
  xdg.configFile."kitty" = linkApp "kitty";
}
