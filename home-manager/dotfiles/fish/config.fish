if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting

alias zj zellij
alias vim nvim
alias ls eza
alias mvim 'NVIM_APPNAME="nvim-mini" nvim'
alias kvim='NVIM_APPNAME="nvim-kickstart" nvim'
alias hmc 'sudo nix-collect-garbage -d; nix-collect-garbage -d'
alias hms 'home-manager switch --flake .'
alias fhmu 'nix flake update && home-manager switch --flake .'

export SSH_AUTH_SOCK=~/.1password/agent.sock
