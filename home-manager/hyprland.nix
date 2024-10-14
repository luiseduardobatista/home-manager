{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    waybar
    mako
    libnotify
    swww
    kitty
    rofi-wayland
    wl-clipboard
    xfce.thunar
    nwg-look
    brightnessctl
    networkmanagerapplet
    bluez # Bluetooth package
    overskride #bluetooth manager

    # HyprPanel
    inputs.hyprpanel.packages."${pkgs.system}".default
  ];
}
