if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

function sesh_interactive
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
end

function ct
    if test -z "$argv"
        cargo nextest run
    else
        cargo nextest $argv
    end
end

# function refresh_env
#     # Pega a var do ambiente atual (COSMIC) e injeta na sessão do Tmux
#     tmux set-environment -g WAYLAND_DISPLAY $WAYLAND_DISPLAY
#     echo "Ambiente Tmux atualizado para $WAYLAND_DISPLAY"
# end

alias zj zellij
alias vim nvim
alias ls eza
alias mvim 'NVIM_APPNAME="mvim" nvim'
alias kvim='NVIM_APPNAME="nvim-kickstart" nvim'
alias hmc 'sudo nix-collect-garbage -d; nix-collect-garbage -d'
alias hms 'home-manager switch --flake .'
alias fhmu 'nix flake update && home-manager switch --flake .'
alias testsum='gotestsum --format=testdox'
bind \cf sesh_interactive

export SSH_AUTH_SOCK=~/.1password/agent.sock

fish_add_path /usr/local/go/bin
starship init fish | source
