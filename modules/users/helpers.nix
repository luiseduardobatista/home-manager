{
  config,
  isNixOS,
  repoDir,
  ...
}: let
  liveRepoPath = "${config.home.homeDirectory}/${repoDir}";
in {
  _module.args = {
    inherit liveRepoPath;

    gl = pkg:
      if isNixOS
      then pkg
      else config.lib.nixGL.wrap pkg;
  };
}
