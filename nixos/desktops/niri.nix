{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    pantheon.pantheon-agent-polkit
  ];
  programs.niri.enable = true;
  security.polkit.enable = true;
}
