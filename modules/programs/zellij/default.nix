_: {
  programs.zellij.enable = true;
  xdg.configFile = {
    "zellij/config.kdl".source = ./config.kdl;
    "zellij/layouts/minimal.kdl".source = ./layouts/minimal.kdl;
    "zellij/plugins/zjstatus.wasm".source = ./plugins/zjstatus.wasm;
  };
}
