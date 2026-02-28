{
  pkgs,
  gl,
  ...
}: {
  programs.foot = {
    enable = true;
    package = gl pkgs.foot;
  };
}
