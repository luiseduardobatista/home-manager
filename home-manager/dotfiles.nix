{ pkgs, config, ... }:
let
  # Função para verificar se o caminho é um diretório
  isDirectory = path: (builtins.pathExists path) && (builtins.isDir path);
  # Diretório contendo as configurações
  configDir = ../configs;
  # Lista de subdiretórios em configDir
  subdirs = builtins.filter isDirectory (builtins.attrNames (builtins.readDir configDir));
in
{
  home.file = builtins.listToAttrs (map (dir: {
    name = ".config/${dir}";
    value.source = config.lib.file.mkOutOfStoreSymlink "${configDir}/${dir}";
  }) subdirs);
}

