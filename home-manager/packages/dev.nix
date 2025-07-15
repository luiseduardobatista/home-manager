{pkgs, ...}: {
  home.packages = with pkgs; [
    gnumake
    unzip
    poetry
    openfortivpn
    golines
    gopls
    air
    sqlc
    stow
    nodePackages.localtunnel
    aws-sam-cli
    awscli
    eza
  ];
}
