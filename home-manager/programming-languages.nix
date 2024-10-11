{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    rustup
    nodejs
    alejandra
  ];
}
