{isNixOS, ...}: {
  programs.mise = {
    enable = !isNixOS;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    globalConfig = {
      tools.go = "latest";
    };
  };
  xdg.configFile."mise/.miseignore".text = ''
    mise/
  '';
}
