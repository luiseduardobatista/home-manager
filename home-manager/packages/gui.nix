{
  pkgs,
  config,
  isNixOS,
  gl,
  ...
}:
let

  nixOSPackages =
    with pkgs;
    if isNixOS then
      [
        brave
      ]
    else
      [ ];
in
{
  home.packages =
    with pkgs;
    [
      (gl jetbrains-toolbox)
    ]
    ++ nixOSPackages;
}
