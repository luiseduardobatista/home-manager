{
  linkApp,
  ...
}:
{
  programs.tmux.enable = true;
  xdg.configFile."tmux/tmux.conf".enable = false;
  xdg.configFile."tmux" = linkApp "tmux";
}
