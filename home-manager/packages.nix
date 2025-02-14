{
  pkgs,
  config,
  isNixOS,
  pkgs-unstable,
  ...
}: let
  nixGLwrap = pkg:
    if isNixOS
    then pkg
    else config.lib.nixGL.wrap pkg;

  cliTools = with pkgs; [
    zoxide
    lazygit
    lazydocker
    btop
    tree
  ];

  devTools = with pkgs; [
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
  ];

  neovimDependencies = with pkgs; [
    fd
    ripgrep
    gcc
    git
    wget
    curl
    xclip
    fzf
  ];

  fonts = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  langs = with pkgs; [
    go
    rustup
    nodejs
    alejandra
  ];

  utils = with pkgs; [
    (nixGLwrap obsidian)
    vlc
    youtube-music
    gearlever
  ];

  unstablePackages = with pkgs-unstable; [
    neovim

    # TWM
    # kanshi
    # (nixGLwrap wdisplays)
    # wlr-randr
  ];

  nixOSPackages = with pkgs;
    if isNixOS
    then [
      wezterm
      alacritty
      python3
      brave
      flameshot
    ]
    else [];
in {
  fonts.fontconfig.enable = true;
  home.packages = cliTools ++ devTools ++ neovimDependencies ++ fonts ++ langs ++ utils ++ unstablePackages ++ nixOSPackages;
  programs.zoxide.enable = true;
}
