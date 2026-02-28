{isNixOS, ...}: {
  programs.mise = {
    enable = !isNixOS;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
