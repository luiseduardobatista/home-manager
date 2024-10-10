{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages =
    (with pkgs; [
      fd
      ripgrep
      gcc
      git
      wget
      curl
      xclip
    ])
    ++ (with pkgs-unstable; [
      neovim
    ]);

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # programs.neovim = {
  #   enable = true;
  #   defaultEditor = true;
  # };
}
