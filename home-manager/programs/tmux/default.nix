{
  pkgs,
  linkFile,
  ...
}:
{
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
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir '~/.tmux/resurrect'
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
      source-file ~/.config/tmux/tmux.conf
    '';
  };

  xdg = {
    configFile = {
      "tmux/tmux.conf" = linkFile "programs/tmux/config/tmux.conf";
      "tmux/statusline.conf" = linkFile "programs/tmux/config/statusline.conf";
      "tmux/statusline_tokyo_night.conf" = linkFile "programs/tmux/config/statusline_tokyo_night.conf";
    };
  };
}
