{
  pkgs,
  config,
  ...
}: let
  nixGL = import ./nixGL.nix {inherit pkgs config;};
in {
  home.packages = with pkgs; [
    # (nixGL wezterm)
    jetbrains-toolbox
    vscode
    dbeaver-bin
    insomnia
    remmina
    gnumake
    unzip
    poetry
    openfortivpn
    golines
    stow
    nodePackages.localtunnel
  ];
}
