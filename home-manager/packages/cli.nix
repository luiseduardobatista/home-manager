{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    lazydocker
    btop
    tree
    zsh
    fish
    gemini-cli
    sesh
  ];

  programs.zoxide.enable = true;
}
