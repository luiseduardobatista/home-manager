{
  pkgs,
  isNixOS,
  ...
}: {
  home.packages = with pkgs;
    [
      go
      rustup
      nodejs
      alejandra
    ]
    ++ (
      if isNixOS
      then [python3]
      else []
    );
}
