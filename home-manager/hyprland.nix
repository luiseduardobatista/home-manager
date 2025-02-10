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
    nwg-displays # Display Manager
    brightnessctl
    networkmanagerapplet
    bluez # Bluetooth package
    overskride #bluetooth manager
  ];
}
