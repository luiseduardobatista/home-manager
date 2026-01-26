{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
  ];
  networking.hostName = "desktop";

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  environment.systemPackages = with pkgs; [pantheon.pantheon-agent-polkit];

  programs.niri.enable = true;

  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
    {
      "rules": [
        {
          "pattern": {
            "feature": "procname",
            "matches": "niri"
          },
          "profile": "Limit Free Buffer Pool On Wayland Compositors"
        }
      ],
      "profiles": [
        {
          "name": "Limit Free Buffer Pool On Wayland Compositors",
          "settings": [
            {
              "key": "GLVidHeapReuseRatio",
              "value": 0
            }
          ]
        }
      ]
    }
  '';
}
