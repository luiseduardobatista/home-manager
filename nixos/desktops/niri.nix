{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    # pantheon.pantheon-agent-polkit
  ];
  programs.niri.enable = true;
  security.polkit.enable = true;

  # Fix high VRAM usage on Nvidia
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
