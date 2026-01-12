{
  linkApp,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  xdg.configFile."nvim" = linkApp "neovim";
}
