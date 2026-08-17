{
  pkgs,
  gl,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = gl pkgs.ghostty;
  };
}
