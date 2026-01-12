{
  linkApp,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  xdg.configFile."nvim" = linkApp "neovim";
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
