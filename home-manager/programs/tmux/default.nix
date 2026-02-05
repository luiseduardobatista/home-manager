{
  pkgs-unstable,
  linkFile,
  ...
}: {
  programs.tmux = {
    enable = true;

    plugins = with pkgs-unstable; [
      tmuxPlugins.vim-tmux-navigator

      # Bloco do RESURRECT
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes '"~nvim" "~vim" "~sesh" "~btop" "~htop"'
        '';
      }

      # Bloco do CONTINUUM (Aqui é onde a ordem importa mais)
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    # Aqui só chamamos o seu arquivo de atalhos/visual
    extraConfig = ''
      source-file ~/.config/tmux/tmux.user.conf
    '';
  };

  # Seus links (mantidos iguais)
  xdg.configFile."tmux/tmux.user.conf" = linkFile "programs/tmux/config/tmux.conf";
  xdg.configFile."tmux/statusline.conf" = linkFile "programs/tmux/config/statusline.conf";
  xdg.configFile."tmux/statusline_tokyo_night.conf" = linkFile "programs/tmux/config/statusline_tokyo_night.conf";
}
