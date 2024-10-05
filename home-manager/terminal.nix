{ pkgs, config, ... }:
let
  nixGL = import ./nixGL.nix { inherit pkgs config; };
in
{
  home.packages = with pkgs; [
    zoxide
    #wezterm
    (nixGL wezterm)
  ];
  programs.zoxide.enable = true;
}
