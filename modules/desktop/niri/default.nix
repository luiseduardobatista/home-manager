{
  flake.modules.nixos.niri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      pantheon.pantheon-agent-polkit
    ];
    programs.niri.enable = true;
    security.polkit.enable = true;
  };

  flake.modules.homeManager.niri = {
    pkgs,
    linkFile,
    ...
  }: {
    home.packages = with pkgs; [
      fuzzel
    ];
    xdg.configFile."niri" = linkFile "sessions/niri/config";
  };
}
