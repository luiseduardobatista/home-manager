{
  pkgs,
  linkFile,
  ...
}: {
  home.packages = with pkgs; [
    moreutils # usado pelo hook do resurrect (sponge)
  ];

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      continuum
    ];
    extraConfig = "source-file ~/.config/tmux/tmux.user.conf";
  };

  xdg.configFile."tmux/tmux.user.conf" = linkFile "programs/tmux/config/tmux.conf";
}
