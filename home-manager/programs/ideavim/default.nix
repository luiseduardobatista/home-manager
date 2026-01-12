{
  config,
  pkgs,
  nixConfigPath,
  ...
}: {
  home.file.".ideavimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/ideavim/config/.ideavimrc";
  home.file.".lazy-idea.vim".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/ideavim/config/.lazy-idea.vim";
}
