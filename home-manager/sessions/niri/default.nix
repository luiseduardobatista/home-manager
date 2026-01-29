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

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";

    timeouts = [
      {
        timeout = 300;
        command = "noctalia-shell ipc call lockScreen lock";
      }
      {
        timeout = 600;
        command = "noctalia-shell ipc call sessionMenu lockAndSuspend";
      }
    ];

    events = [
      {
        event = "before-sleep";
        command = "noctalia-shell ipc call lockScreen lock";
      }
    ];
  };

  systemd.user.services.swayidle.Unit.ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=niri";
}
