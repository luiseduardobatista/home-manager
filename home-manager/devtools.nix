{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-fhs
    dbeaver-bin
    insomnia
    remmina
    gnumake
    unzip
    poetry
    openfortivpn
    golines
  ];
}
