{...}: {
  programs.zellij.enable = true;
  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;
  xdg.configFile."zellij/layouts/minimal.kdl".source = ./zellij/layouts/minimal.kdl;
  xdg.configFile."zellij/plugins/zjstatus.wasm".source = ./zellij/plugins/zjstatus.wasm;
}
