{
  flake.modules.homeManager.noctalia = {
    config,
    liveRepoPath,
    ...
  }: {
    programs.noctalia.enable = true;

    xdg.configFile."noctalia/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${liveRepoPath}/modules/desktop/noctalia/config.toml";

    xdg.configFile."noctalia/palettes/kame-house-mc.json".source = ./palettes/kame-house-mc.json;
  };
}
