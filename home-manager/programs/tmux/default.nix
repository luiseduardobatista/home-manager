{
  pkgs,
  linkFile,
  ...
}: {
  home.packages = with pkgs; [
    sesh
    fzf
    fd
    ripgrep
    xclip
  ];
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      source-file ~/.config/tmux/tmux.conf

      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-dir '~/.tmux/resurrect'
      set -g @resurrect-processes '"~nvim" "~vim" "~sesh" "~btop" "~htop"'

      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux

      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'

      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
  xdg.configFile."tmux/tmux.conf" = linkFile "programs/tmux/config/tmux.conf";
  xdg.configFile."tmux/statusline.conf" = linkFile "programs/tmux/config/statusline.conf";
  xdg.configFile."tmux/statusline_tokyo_night.conf" = linkFile "programs/tmux/config/statusline_tokyo_night.conf";
}
