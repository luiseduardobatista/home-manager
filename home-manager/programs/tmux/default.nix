{
  pkgs,
  lib,
  ...
}: let
  gray_light = "#D8DEE9";
  gray_dark = "#3B4252";
  green_soft = "#A3BE8C";
  blue_muted = "#81A1C1";
  cyan_soft = "#88C0D0";
in {
  home.packages = with pkgs; [
    moreutils
  ];

  programs.tmux = {
    enable = true;
    prefix = "C-f";
    mouse = true;
    escapeTime = 0;
    historyLimit = 50000;
    baseIndex = 1;
    terminal = "tmux-256color";
    keyMode = "vi";
    focusEvents = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          resurrect_dir="$XDG_CACHE_HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
          set -g @continuum-systemd-start-cmd 'start-server'
        '';
      }
    ];
    extraConfig = ''
      # ==========================================
      # GERAL
      # ==========================================
      set -g display-time 4000
      set -g status-interval 3
      set -g renumber-windows on
      set -g detach-on-destroy off
      set -g extended-keys on
      set -g extended-keys-format csi-u
      set-option -sa terminal-overrides ",xterm*:Tc"
      bind R source-file ~/.config/tmux/tmux.conf \; display "Configuração Recarregada!"
      # ==========================================
      # MODO NORMAL
      # ==========================================
      # Menus (Sub-modos)
      bind-key p switch-client -T pane
      bind-key r switch-client -T resize
      bind-key t switch-client -T tab
      bind-key m switch-client -T move
      bind-key s switch-client -T scroll
      bind-key o switch-client -T session
      # Ações Rápidas
      bind-key / copy-mode \; send-keys ?
      bind-key 1 select-window -t 1
      bind-key 2 select-window -t 2
      bind-key 3 select-window -t 3
      bind-key 4 select-window -t 4
      bind-key 5 select-window -t 5
      # ==========================================
      # MODO PANE (Menu 'p')
      # ==========================================
      bind-key -T pane f resize-pane -Z \; switch-client -T root
      bind-key -T pane - split-window -v \; switch-client -T root
      bind-key -T pane r split-window -h \; switch-client -T root
      bind-key -T pane | split-window -h \; switch-client -T root
      bind-key -T pane x kill-pane \; switch-client -T root
      bind-key -T pane c command-prompt -I "#T" "select-pane -T '%%'" \; switch-client -T pane
      bind-key -T pane h select-pane -L \; switch-client -T pane
      bind-key -T pane j select-pane -D \; switch-client -T pane
      bind-key -T pane k select-pane -U \; switch-client -T pane
      bind-key -T pane l select-pane -R \; switch-client -T pane
      bind-key -T pane Escape switch-client -T root
      bind-key -T pane Enter switch-client -T root
      # ==========================================
      # MODO TAB (Menu 't')
      # ==========================================
      bind-key -T tab n new-window \; switch-client -T root
      bind-key -T tab r command-prompt -I "#W" "rename-window '%%'" \; switch-client -T tab
      bind-key -T tab x kill-window \; switch-client -T root
      bind-key -T tab h previous-window \; switch-client -T tab
      bind-key -T tab l next-window \; switch-client -T tab
      bind-key -T tab Left previous-window \; switch-client -T tab
      bind-key -T tab Right next-window \; switch-client -T tab
      bind-key -T tab Escape switch-client -T root
      bind-key -T tab Enter switch-client -T root
      # ==========================================
      # MODO RESIZE (Menu 'r')
      # ==========================================
      bind-key -T resize h resize-pane -L 5 \; switch-client -T resize
      bind-key -T resize j resize-pane -D 5 \; switch-client -T resize
      bind-key -T resize k resize-pane -U 5 \; switch-client -T resize
      bind-key -T resize l resize-pane -R 5 \; switch-client -T resize
      bind-key -T resize p switch-client -T pane
      bind-key -T resize s switch-client -T scroll
      bind-key -T resize Escape switch-client -T root
      bind-key -T resize Enter switch-client -T root
      # ==========================================
      # MODO MOVE (Menu 'm')
      # ==========================================
      bind-key -T move h swap-pane -s '{left-of}' \; switch-client -T move
      bind-key -T move j swap-pane -s '{down-of}' \; switch-client -T move
      bind-key -T move k swap-pane -s '{up-of}' \; switch-client -T move
      bind-key -T move l swap-pane -s '{right-of}' \; switch-client -T move
      bind-key -T move n next-layout \; switch-client -T move
      bind-key -T move Escape switch-client -T root
      bind-key -T move Enter switch-client -T root
      # ==========================================
      # MODO SCROLL / SEARCH (Menu 's')
      # ==========================================
      bind-key -T scroll f copy-mode \; send-keys ?
      bind-key -T scroll e copy-mode \; switch-client -T root
      bind-key -T scroll s switch-client -T root
      bind-key -T scroll Escape switch-client -T root
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Escape send-keys -X cancel
      # ==========================================
      # MODO SESSION (Menu 'o')
      # ==========================================
      bind-key -T session d detach-client
      bind-key -T session r command-prompt -I "#S" "rename-session '%%'"
      bind-key -T session w run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 90%,90% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  C-a All | C-t Tmux | C-x Zoxide | C-f Find | C-d Kill Session' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:50%' \
          --preview 'sesh preview {}'
      )\""
      bind-key -T session Escape switch-client -T root
      bind-key -T session Enter switch-client -T root
      # ==========================================
      # SMART SPLITS (Navegação Vim/Tmux)
      # ==========================================
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'
      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
      # ==========================================
      # STATUSLINE
      # ==========================================
      set -g status-position top
      set -g status-left-length 100
      set -g status-style "fg=${gray_light},bg=default"
      set -g status-left "#[fg=${green_soft},bold] #S #[fg=${gray_light},nobold] | "
      set -g status-right " #(~/.config/tmux/monitor.sh cpu)   #(~/.config/tmux/monitor.sh mem) "
      set -g window-status-current-format "#[fg=${cyan_soft},bold]  #[underscore]#I:#W#[nounderscore]#{?window_zoomed_flag, 󰍋 ,}"
      set -g window-status-format " #I:#W"
      set -g message-style "fg=${gray_light},bg=default"
      set -g mode-style "fg=${gray_dark},bg=${blue_muted}"
      set -g pane-border-style "fg=${gray_dark}"
      set -g pane-active-border-style "fg=${green_soft}"
    '';
  };
  xdg.configFile."tmux/monitor.sh" = {
    source = ./monitor.sh;
    executable = true;
  };
}
