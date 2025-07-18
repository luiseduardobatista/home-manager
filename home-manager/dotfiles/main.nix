{
  config,
  pkgs,
  ...
}: let
  dotfilesPath = "/home/luisb/nix/home-manager/dotfiles";
  createSymLink = srcPath: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${srcPath}";
  dotfilesToLink = [
    "wezterm"
    "foot"
    "kitty"
    "fish/config.fish"
    "1Password/ssh/agent.toml"
    "nvim"
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
