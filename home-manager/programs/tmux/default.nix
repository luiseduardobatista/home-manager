{
  pkgs-unstable,
  linkFile,
  ...
}: {
  programs.tmux = {
    enable = true;

    plugins = with pkgs-unstable; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
    extraConfig = ''
      source-file ~/.config/tmux/tmux.user.conf
    '';
  };

  xdg.configFile."tmux/tmux.user.conf" = linkFile "programs/tmux/config/tmux.conf";
  xdg.configFile."tmux/statusline.conf" = linkFile "programs/tmux/config/statusline.conf";
  xdg.configFile."tmux/statusline_tokyo_night.conf" = linkFile "programs/tmux/config/statusline_tokyo_night.conf";
}
