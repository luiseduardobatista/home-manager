{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh-syntax-highlighting
    zsh-history
    zsh-autosuggestions
    zsh-powerlevel10k
  ];

  programs = {
      zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
              "git"
              "history"
            ];
          };
      };
  };
}
