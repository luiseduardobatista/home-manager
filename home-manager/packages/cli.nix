{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [
    zoxide
    lazygit
    lazydocker
    btop
    tree
    zsh
    fish
    gemini-cli
  ];

  programs.zoxide.enable = true;
}
