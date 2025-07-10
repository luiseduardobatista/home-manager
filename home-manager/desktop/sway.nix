{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    waybar
    rofi-wayland
    kanshi
    dunst
    wl-clipboard
    xfce.thunar
    nwg-look
    nwg-displays # Display Manager
    brightnessctl
    networkmanagerapplet
    bluez # Bluetooth package
    overskride #bluetooth manager
  ];
}
