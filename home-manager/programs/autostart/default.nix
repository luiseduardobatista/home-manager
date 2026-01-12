{
  pkgs,
  lib,
  isNixOS,
  ...
}: {
  xdg.configFile."autostart/1password.desktop" = lib.mkIf isNixOS {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=1Password
      Exec=${pkgs._1password-gui}/bin/1password --silent
      Terminal=false
    '';
  };
}
