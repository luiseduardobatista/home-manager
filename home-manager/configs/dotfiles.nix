{config, ...}: let
  dotfiles = builtins.fetchGit {
    url = "https://github.com/luiseduardobatista/dotfiles.git";
    submodules = true;
  };
in {
  home.file = {
    ".config/wezterm/".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wezterm/.config/wezterm";
  };
}
