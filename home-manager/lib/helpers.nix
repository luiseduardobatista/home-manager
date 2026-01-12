{
  config,
  lib,
  isNixOS,
  repoDir,
  ...
}:

let
  nixConfigPath = "${config.home.homeDirectory}/${repoDir}/home-manager";
in
{
  # _module.args disponibiliza variáveis para TODOS os módulos importados
  _module.args = {
    linkApp = name: {
      source = config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/programs/${name}/config";
    };
    inherit nixConfigPath;

    gl = pkg: if isNixOS then pkg else config.lib.nixGL.wrap pkg;

  };

}
