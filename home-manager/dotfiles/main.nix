{
  config,
  pkgs,
  ...
}: let
  dotfilesPath = "/home/luisb/nix/home-manager/dotfiles";
  createSymLink = name: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${name}";
  dotfilesToLink = [
    "wezterm"
    "foot"
    "kitty"
    "fish/config.fish"
    "1Password/ssh/agent.toml"
  ];
in {
  xdg.configFile = pkgs.lib.listToAttrs (map (name: {
      name = name;
      value = {source = createSymLink name;};
    })
    dotfilesToLink);
  # home.file.".config/nvim".source = inputs.lazyvim;
}
