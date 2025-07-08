{
  config,
  inputs,
  ...
}: {
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink (toString ./wezterm);
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink (toString ./foot);
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink (toString ./kitty);
    ".config/nvim".source = inputs.lazyvim;
    ".config/fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink (toString ./fish/config.fish);
  };
}
