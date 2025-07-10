{pkgs, ...}: {
  home.packages = with pkgs; [
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
