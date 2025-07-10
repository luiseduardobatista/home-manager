{
  pkgs,
  isNixOS,
  ...
}: let
  nixOSPackages =
    if isNixOS
    then [
      pkgs.python3
    ]
    else [];
in {
  home.packages = with pkgs;
    [
      rustup
      alejandra
      nodejs
      go
    ]
    ++ nixOSPackages;
}
