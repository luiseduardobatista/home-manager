{
  config,
  pkgs,
  ...
}: let
  dotfilesPath = "/home/luisb/nix/home-manager/dotfiles";
  createSymLink = sourceName: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${sourceName}";
  dotfilesToLink = [
    "wezterm"
    "foot"
    "kitty"
    "fish/config.fish"
    "1Password/ssh"
    "nvim"
    "tmux"
    "zellij"
  ];
in {
  xdg.configFile = pkgs.lib.listToAttrs (map (
      item:
        if pkgs.lib.isString item
        then {
          name = item;
          value = {source = createSymLink item;};
        }
        else {
          name = item.target;
          value = {source = createSymLink item.source;};
        }
    )
    dotfilesToLink);
}
