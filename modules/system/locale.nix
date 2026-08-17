{
  flake.modules.nixos.locale = {lib, ...}: {
    time.timeZone = "America/Sao_Paulo";
    i18n.defaultLocale = "pt_BR.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    # Configure console keymap
    console.keyMap = "dvorak";

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = lib.mkDefault "us";
      variant = lib.mkDefault "alt-intl";
    };

    i18n.inputMethod = {
      enable = false;
      type = "fcitx5";
    };

    environment.variables = {
      GTK_IM_MODULE = lib.mkForce "simple";
      QT_IM_MODULE = lib.mkForce "simple";
      XMODIFIERS = lib.mkForce "@im=none";
    };
  };
}
