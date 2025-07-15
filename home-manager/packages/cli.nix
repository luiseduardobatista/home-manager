{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    lazydocker
    btop
    tree
    zsh
    fish
    gemini-cli
  ];

  programs.zoxide.enable = true;
}
