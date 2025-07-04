{
  config,
  inputs,
  ...
}: {
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink (toString ./wezterm);
    ".config/foot".source = config.lib.file.mkOutOfStoreSymlink (toString ./foot);
    ".config/nvim-teste".source = inputs.lazyvim;
  };
}
