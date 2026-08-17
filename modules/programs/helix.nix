{
  pkgs,
  lib,
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
    settings = {
      theme = "gruvbox_dark_hard";
      editor.line-number = "relative";
      keys.normal.esc = [
        "collapse_selection"
        "keep_primary_selection"
      ];
      editor.cursor-shape.insert = "bar";
    };
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
          language-servers = [
            "basedpyright"
            "ruff"
          ];
          formatter = {
            command = "ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
      ];
      language-server = {
        basedpyright = {
          command = "basedpyright-langserver";
          args = ["--stdio"];
          config.basedpyright.analysis = {
            autoSearchPaths = true;
            diagnosticMode = "openFilesOnly";
            typeCheckingMode = "standard";
          };
        };
        ruff = {
          command = "ruff";
          args = ["server"];
          config.settings.lineLength = 100;
        };
      };
    };
  };
}
