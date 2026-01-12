{_}: {
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    packages = [
      "org.flameshot.Flameshot"
      "com.usebruno.Bruno"
      "org.remmina.Remmina"
      "it.mijorus.gearlever"
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
      "io.dbeaver.DBeaverCommunity"
      "com.github.wwmm.easyeffects"
      "org.telegram.desktop"
    ];
  };
}
