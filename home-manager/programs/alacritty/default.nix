{
  pkgs,
  gl,
  ...
}: {
  programs.alacritty = {
    enable = true;
    package = gl pkgs.alacritty;
  };
}
