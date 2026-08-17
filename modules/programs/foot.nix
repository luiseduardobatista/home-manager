{
  pkgs,
  linkApp,
  gl,
  ...
}: {
  programs.foot = {
    enable = true;
    package = gl pkgs.foot;
  };
  xdg.configFile."foot" = linkApp "foot";
}
