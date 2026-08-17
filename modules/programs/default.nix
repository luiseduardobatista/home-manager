{
  flake.modules.homeManager = {
    onepassword = ./onepassword.nix;
    alacritty = ./alacritty.nix;
    cli = ./cli.nix;
    zoxide = ./zoxide.nix;
    flameshot = ./flameshot.nix;
    foot = ./foot.nix;
    ghostty = ./ghostty.nix;
    git = ./git.nix;
    kitty = ./kitty.nix;
    mise = ./mise.nix;
    neovim = ./neovim.nix;
    ssh = ./ssh.nix;
    tmux = ./tmux.nix;
    wezterm = ./wezterm.nix;
    whisper = ./whisper.nix;
    flatpak = ./flatpak.nix;
    jetbrains-toolbox = ./jetbrains-toolbox.nix;
    dev-langs = ./dev-langs.nix;
    helix = ./helix.nix;
    zed = ./zed.nix;
    zellij = ./zellij;
    opencode = ./opencode.nix;
    pi = ./pi.nix;
    fish = ./fish.nix;
    zsh = ./zsh.nix;
    starship = ./starship.nix;
    fonts = ./fonts.nix;
  };
}
