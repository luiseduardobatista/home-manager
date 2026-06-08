{linkApp, ...}: {
  programs.pi.coding-agent = {
    enable = true;
  };
  # xdg.configFile."mise" = linkApp "mise";
}
