{...}: {
  services.flatpak.enable = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }
  ];
  services.flatpak.packages = [
    "com.brave.Browser"
    "io.github.zen_browser.zen"
    "org.remmina.Remmina"
    "io.dbeaver.DBeaverCommunity"
    "org.flameshot.Flameshot"
    "md.obsidian.Obsidian"
  ];
}
