{ pkgs, pkgs-unstable, isNixOS, ... }:
let
  nixOSPackages =
    if isNixOS
    then [
      pkgs-unstable.python3
    ]
    else [];
in
{
  home.packages = with pkgs-unstable; [
    rustup
    alejandra
    nodejs
    go
  ] ++ nixOSPackages;
}
