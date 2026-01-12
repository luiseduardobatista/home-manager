{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  home.packages = with pkgs; [
    fd
    ripgrep
    gcc
    wget
    curl
    xclip
    fzf
  ];
}
