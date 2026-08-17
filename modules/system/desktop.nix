{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      host
      audio
      printing
      fonts
      gnome
      niri
      v4l2loopback
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      xclip
      brave
      libreoffice
    ];

    programs.firefox.enable = true;

    services.flatpak.enable = true;

    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = ["luisb"];
    };
  };
}
