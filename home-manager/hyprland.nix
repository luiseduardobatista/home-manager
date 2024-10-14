{
  pkgs,
  config,
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
  ];
}
