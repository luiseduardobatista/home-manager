{...}: {
  xdg.configFile = {
    "pop-shell/config.json".text = ''
      {
        "float": [
          {
            "class": "ulauncher"
          }
        ],
        "skiptaskbarhidden": [
          {
            "class": "ulauncher"
          }
        ],
        "log_on_focus": false
      }
    '';
  };
}
