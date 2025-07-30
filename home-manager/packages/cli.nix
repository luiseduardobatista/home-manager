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
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    plugins = {
      no-status = pkgs.yaziPlugins.no-status;
    };
  };
}
