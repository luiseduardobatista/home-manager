{
  lib,
  pkgs,
  isNixOS,
  ...
}: {
  xdg.configFile = {
    "1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "Pessoal"

      [[ssh-keys]]
      vault = "Kyros"
    '';
    "autostart/1password.desktop" = lib.mkIf isNixOS {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=1Password
        Exec=sh -c "${pkgs.coreutils}/bin/sleep 5 && ${pkgs._1password-gui}/bin/1password --silent"
        Terminal=false
      '';
    };
  };
}
