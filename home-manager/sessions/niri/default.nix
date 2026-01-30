{
  config,
  lib,
  pkgs,
  isNixOS,
  linkFile,
  ...
}: {
  home.packages = with pkgs; [
    fuzzel
  ];
  xdg.configFile."niri" = linkFile "sessions/niri/config";

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "noctalia-shell ipc call lockScreen lock";
        }
        {
          timeout = 600;
          on-timeout = "noctalia-shell ipc call sessionMenu lockAndSuspend";
        }
      ];
    };
  };

  systemd.user.services.hypridle = {
    Unit = {
      # Use mkForce em tudo o que conflitar com o padrão do módulo
      Description = lib.mkForce "Idle Daemon para Niri";
      ConditionEnvironment = lib.mkForce "NIRI_SOCKET";
      PartOf = lib.mkForce ["niri.service"];
      After = lib.mkForce ["niri.service"];
    };
    Install = {
      WantedBy = lib.mkForce ["niri.service"];
    };
  };
}
