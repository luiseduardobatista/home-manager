{
  pkgs,
  lib,
  isNixOS,
  ...
}: {
  home.packages = with pkgs;
    [
      rustup
    ]
    ++ lib.optionals isNixOS [
      python3
      go
    ];
}
