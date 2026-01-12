{
  linkApp,
  ...
}:
{
  programs.tmux.enable = true;
  xdg.configFile."tmux" = linkApp "tmux";
}
