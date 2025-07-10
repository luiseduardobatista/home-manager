{pkgs, ...}: {
  home.packages = with pkgs; [
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
