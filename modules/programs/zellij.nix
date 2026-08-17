_: {
  programs.zellij.enable = true;
  xdg.configFile = {
    "zellij/config.kdl".source = ./zellij/config.kdl;
    "zellij/layouts/minimal.kdl".source = ./zellij/layouts/minimal.kdl;
    "zellij/plugins/zjstatus.wasm".source = ./zellij/plugins/zjstatus.wasm;
  };
}
