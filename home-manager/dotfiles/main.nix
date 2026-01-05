{
  config,
  pkgs,
  ...
}: let
  dotfilesPath = "/home/luisb/nix/home-manager/dotfiles";
  createSymLink = sourceName: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${sourceName}";

  configDotfiles = [
    "wezterm"
    "foot"
    "kitty"
    "1Password/ssh"
    "nvim"
    "tmux"
    "zellij"
    "mise"
    "alacritty"
    "pop-shell"
    "flameshot"
  ];

  homeDotfiles = [
    ".ideavimrc"
    ".lazy-idea.vim"
  ];
in {
  xdg.configFile = pkgs.lib.listToAttrs (
    map (
      item:
        if pkgs.lib.isString item
        then {
          name = item;
          value = {
            source = createSymLink item;
          };
        }
        else {
          name = item.target;
          value = {
            source = createSymLink item.source;
          };
        }
    )
    configDotfiles
  );

  home.file = pkgs.lib.listToAttrs (
    map (
      item:
        if pkgs.lib.isString item
        then {
          name = item;
          value = {
            source = createSymLink item;
          };
        }
        else {
          name = item.target;
          value = {
            source = createSymLink item.source;
          };
        }
    )
    homeDotfiles
  );
}
