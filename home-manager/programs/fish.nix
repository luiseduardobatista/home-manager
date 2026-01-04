{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    sesh
    fzf
    eza
    gotestsum
    cargo-nextest
    fd
  ];
  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    MOZ_ENABLE_WAYLAND = "1";
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
      bind \cf sesh_interactive
    '';
    shellAliases = {
      zj = "zellij";
      vim = "nvim";
      ls = "eza";
      mvim = "NVIM_APPNAME=\"mvim\" nvim";
      kvim = "NVIM_APPNAME=\"nvim-kickstart\" nvim";
      hmc = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
      hms = "home-manager switch --flake .";
      fhmu = "nix flake update && home-manager switch --flake .";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix";
      update = "nix flake update --flake ~/nix && sudo nixos-rebuild switch --flake ~/nix";
      clean = "nix-collect-garbage -d";
      testsum = "gotestsum --format=testdox";
    };
    functions = {
      ct = ''
        if test -z "$argv"
            cargo nextest run
        else
            cargo nextest $argv
        end
      '';
      refresh_env = ''
        tmux set-environment -g WAYLAND_DISPLAY $WAYLAND_DISPLAY
        echo "Ambiente Tmux atualizado para $WAYLAND_DISPLAY"
      '';
      sesh_interactive = ''
        set -l session (sesh list --icons | fzf --height 90% --layout=reverse \
            --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
            --header '  C-a All | C-t Tmux | C-g Configs | C-x Zoxide | C-f Find | C-d Kill Session' \
            --bind 'tab:down,btab:up' \
            --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
            --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
            --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
            --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
            --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
            --preview-window 'right:50%' \
            --preview 'sesh preview {}' < /dev/tty)
        commandline -f repaint >/dev/null 2>&1
        if test -z "$session"
            return
        end
        set -l session_name (string split -f 2 ' ' "$session")
        sesh connect "$session_name"
      '';
    };
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
