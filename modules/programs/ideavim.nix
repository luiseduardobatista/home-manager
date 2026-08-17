{
  config,
  pkgs,
  nixConfigPath,
  linkFile,
  ...
}: {
  home.file.".ideavimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/ideavim/config/.ideavimrc";
  home.file.".lazy-idea.vim".source =
    config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/ideavim/config/.lazy-idea.vim";
  home.file.".lazy-idea".source = (linkFile "programs/ideavim/config/lazy-idea").source;
}
