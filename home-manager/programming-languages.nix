{pkgs, ...}: {
  home.packages = with pkgs; [
    python3
    rustup
    nodejs
    go
    clojure
    alejandra
  ];
}
