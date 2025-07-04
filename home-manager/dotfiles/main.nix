{
  config,
  inputs,
  ...
}: {
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink (toString ./wezterm);
    ".config/nvim-teste".source = inputs.lazyvim;
  };
}
