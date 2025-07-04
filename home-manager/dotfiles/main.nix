{
  config,
  inputs,
  ...
}: {
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink (toString ./wezterm);
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink (toString ./foot);
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink (toString ./kitty);
    ".config/nvim-teste".source = inputs.lazyvim;
  };
}
