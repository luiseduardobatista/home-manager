{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    zoxide
    lazygit
    lazydocker
    btop
  ];
  programs.zoxide.enable = true;
}
