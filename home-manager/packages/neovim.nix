{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [
    fd
    ripgrep
    gcc
    wget
    curl
    xclip
    fzf
    neovim
  ];
}
