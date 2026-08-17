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
    config,
    pkgs,
    liveRepoPath,
    ...
  }: {
    home.packages = with pkgs; [
      fuzzel
    ];

    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${liveRepoPath}/modules/desktop/niri/config.kdl";

    xdg.configFile."niri/noctalia.kdl".source = ./noctalia.kdl;
    xdg.configFile."niri/dms/cursor.kdl".source = ./dms/cursor.kdl;
    xdg.configFile."niri/dms/outputs.kdl".source = ./dms/outputs.kdl;
    xdg.configFile."niri/dms/windowrules.kdl".source = ./dms/windowrules.kdl;
    xdg.configFile."niri/dms/binds.kdl".source = ./dms/binds.kdl;
    xdg.configFile."niri/dms/colors.kdl".source = ./dms/colors.kdl;
  };
}
