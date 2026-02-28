{
  linkApp,
  linkFile,
  ...
}: {
  xdg.configFile = {
    "alacritty" = linkApp "alacritty";
    "foot" = linkApp "foot";
    "kitty" = linkApp "kitty";
    "wezterm" = linkApp "wezterm";
    "zed" = linkApp "zed";
    "zellij" = linkApp "zellij";
    "helix" = linkApp "helix";
    "mise" = linkApp "mise";
    "flameshot" = linkApp "flameshot";
    "noctalia" = linkApp "noctalia";
    "1Password/ssh" = linkApp "1Password";

    # Arquivos específicos:
    "tmux/tmux.user.conf" = linkFile "programs/tmux/config/tmux.conf";
    "tmux/statusline.conf" = linkFile "programs/tmux/config/statusline.conf";
    "tmux/statusline_tokyo_night.conf" = linkFile "programs/tmux/config/statusline_tokyo_night.conf";

    "opencode/opencode.json" = linkFile "programs/opencode/config/opencode.json";
    "niri" = linkFile "sessions/niri/config";
    "pop-shell" = linkApp "../sessions/gnome/pop-shell";
  };

  # Home files (na raiz)
  home.file = {
    ".ideavimrc" = linkFile "programs/ideavim/config/ideavimrc";
    ".lazy-idea.vim" = linkFile "programs/ideavim/config/lazy-idea.vim";
    ".lazy-idea".source = (linkFile "programs/ideavim/config/lazy-idea").source;
  };
}
