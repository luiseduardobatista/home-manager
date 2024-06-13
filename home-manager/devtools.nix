{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-fhs
    dbeaver-bin
    insomnia
    remmina
    gnumake
    docker
    unzip
    poetry
  ];
}
