{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [
    fd
    ripgrep
    gcc
    git
    wget
    curl
    xclip
    fzf
    neovim
  ];
}
