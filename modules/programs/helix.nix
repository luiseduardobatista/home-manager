{
  pkgs,
  lib,
  linkApp,
  ...
}: let
  extraPackages = with pkgs; [
    nil
    rust-analyzer
    basedpyright
    marksman
    ruff
    lua-language-server
  ];
in {
  programs.helix = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "helix-wrapped";
      paths = [pkgs.helix];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/hx \
          --prefix PATH : "${lib.makeBinPath extraPackages}"
      '';
    };
  };
  xdg.configFile."helix" = linkApp "helix";
}
