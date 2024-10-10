{pkgs, ...}: {
  home.packages = with pkgs; [
    fd
    ripgrep
    gcc
    git
    wget
    curl
    xclip
    neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.neovim.defaultEditor = true;
}
