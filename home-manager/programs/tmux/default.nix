{pkgs-unstable, ...}: {
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
}
