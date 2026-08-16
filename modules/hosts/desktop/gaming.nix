{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.enter-the-wired.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };
  programs.gamemode.enable = true;
}
