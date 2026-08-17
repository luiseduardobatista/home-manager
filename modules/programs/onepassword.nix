{
  lib,
  pkgs,
  linkApp,
  isNixOS,
  ...
}: {
  xdg.configFile."1Password/ssh" = linkApp "1Password";
  xdg.configFile."autostart/1password.desktop" = lib.mkIf isNixOS {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=1Password
      Exec=sh -c "${pkgs.coreutils}/bin/sleep 5 && ${pkgs._1password-gui}/bin/1password --silent"
      Terminal=false
    '';
  };
}
