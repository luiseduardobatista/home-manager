{
  pkgs,
  config,
  isNixOS,
  ...
}: let
  nixGLwrap = pkg:
    if isNixOS
    then pkg
    else config.lib.nixGL.wrap pkg;
in {
  fonts.fontconfig.enable = true;
  imports = [./flatpaks.nix];
  home.packages = with pkgs;
    [
      # CLI
      zoxide
      lazygit
      lazydocker
      btop
      tree

      # Dev Tools
      (nixGLwrap jetbrains-toolbox)
      (nixGLwrap vscode)
      (nixGLwrap dbeaver-bin)
      (nixGLwrap bruno)
      (nixGLwrap remmina)
      gnumake
      unzip
      poetry
      openfortivpn
      golines
      stow
      nodePackages.localtunnel
      aws-sam-cli
      awscli

      # Neovim
      fd
      ripgrep
      gcc
      git
      wget
      curl
      xclip
      fzf

      # Fonts
      (nerdfonts.override {fonts = ["JetBrainsMono"];})

      # Programming Languages
      go
      rustup
      nodejs
      alejandra

      # Utils
      (nixGLwrap obsidian)
      vlc
      youtube-music
      gearlever # Manage appimages
    ]
    ++ (
      if isNixOS
      then [
        wezterm
        alacritty
        python3
        brave
        flameshot
      ]
      else []
    );
  programs.zoxide.enable = true;
}
