{ pkgs, pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [
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
}
