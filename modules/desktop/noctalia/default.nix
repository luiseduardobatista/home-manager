{
  flake.modules.homeManager.noctalia = {linkApp, ...}: {
    programs.noctalia.enable = true;
    xdg.configFile."noctalia" = linkApp "noctalia";
  };
}
