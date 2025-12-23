{pkgs, ...}: {
  home.packages = with pkgs; [
    gnumake
    unzip
    poetry
    openfortivpn
    golines
    gopls
    impl
    gotestsum
    air
    sqlc
    stow
    nodePackages.localtunnel
    eza
    cargo-nextest
    cargo-cache
    nixfmt-rfc-style
    statix
    uv
  ];
}
