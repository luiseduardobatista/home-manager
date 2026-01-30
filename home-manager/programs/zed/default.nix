{
  pkgs-unstable,
  linkApp,
  ...
}: let
  zed-fixed = pkgs-unstable.symlinkJoin {
    name = "zed-fixed";
    paths = [pkgs-unstable.zed-editor-fhs];
    buildInputs = [pkgs-unstable.makeWrapper];
    postBuild = ''
      # 1. Removemos o link para o binário original (que não tem o fix)
      rm $out/bin/zeditor

      # 2. Criamos um "Wrapper" no lugar dele.
      #    Esse comando cria um script chamado 'zeditor' que:
      #    a) Define WAYLAND_DISPLAY=""
      #    b) Chama o zed original
      makeWrapper ${pkgs-unstable.zed-editor-fhs}/bin/zeditor $out/bin/zeditor \
        --set WAYLAND_DISPLAY ""
    '';
  };
in {
  home.packages = [
    zed-fixed
  ];

  xdg.configFile."zed" = linkApp "zed";
}
