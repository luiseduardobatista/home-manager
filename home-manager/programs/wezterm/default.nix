{
  pkgs,
  gl,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = gl pkgs.wezterm;
  };
}
