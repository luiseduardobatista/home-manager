{
  pkgs,
  isNixOS,
  ...
}: {
  home.packages = pkgs.lib.optionals isNixOS (
    with pkgs; [
      jetbrains-toolbox
    ]
  );
}
