{
  pkgs,
  lib,
  isNixOS,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      rustup
      alejandra
      nodejs_24
    ]
    ++ lib.optionals isNixOS [
      python3
      go
    ];
}
