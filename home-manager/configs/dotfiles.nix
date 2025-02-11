{config, ...}: 
 {
  home.file = {
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "./wezterm";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "./nvim";
  };
}
