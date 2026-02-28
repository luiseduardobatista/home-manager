{lib, ...}: {
  options.my.desktop = {
    gnome.enable = lib.mkEnableOption "Ativar configurações do GNOME";
    niri.enable = lib.mkEnableOption "Ativar configurações do Niri (inclui Noctalia e DMS)";
  };
}
