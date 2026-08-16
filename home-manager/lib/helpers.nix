{
  config,
  isNixOS,
  repoDir,
  ...
}: let
  # Compatibilidade temporária: os targets de linkApp/linkFile apontam para o
  # layout físico atual (home-manager/...). Quando um consumidor migrar para
  # modules/, mover o payload junto e atualizar este caminho na mesma mudança
  # (Etapa 3/4) para não gerar symlinks quebrados.
  nixConfigPath = "${config.home.homeDirectory}/${repoDir}/home-manager";
in {
  # _module.args disponibiliza variáveis para TODOS os módulos importados
  _module.args = {
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
