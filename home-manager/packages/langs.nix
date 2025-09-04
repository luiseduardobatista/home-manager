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
      # rustup
      alejandra
      nodejs_24
      # go
    ]
    ++ nixOSPackages;
}
