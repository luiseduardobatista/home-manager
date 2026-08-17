{isNixOS, ...}: {
  programs.mise = {
    enable = !isNixOS;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
  xdg.configFile."mise/config.toml".source = ./mise/config.toml;
  xdg.configFile."mise/.miseignore".source = ./mise/.miseignore;
}
