{
  config,
  isNixOS,
  repoDir,
  ...
}: let
  nixConfigPath = "${config.home.homeDirectory}/${repoDir}/home-manager";
  liveRepoPath = "${config.home.homeDirectory}/${repoDir}";
in {
  _module.args = {
    inherit liveRepoPath;

    linkApp = name: {
      source = config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/${name}/config";
    };

    linkFile = path: {
      source = config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/${path}";
    };

    inherit nixConfigPath;

    gl = pkg:
      if isNixOS
      then pkg
      else config.lib.nixGL.wrap pkg;
  };
}
