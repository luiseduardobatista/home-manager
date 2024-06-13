{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
    zoxide
    wezterm
  ];
  programs.zoxide.enable = true;
}
