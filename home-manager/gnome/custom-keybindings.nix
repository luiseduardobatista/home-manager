let
  inherit (builtins) length listToAttrs genList head tail;

  customBindingPathBase = "org/gnome/settings-daemon/plugins/media-keys";
  customBindingPath = id: "${customBindingPathBase}/custom-keybindings/custom${toString id}";

  # add index to binding and set to format for applying listToAttrs
  mapCustomBinding = index: bindingDefinition: {
    name = customBindingPath index;
    value = {
      name = bindingDefinition.name;
      command = bindingDefinition.command;
      binding = bindingDefinition.binding;
    };
  };
  # returns the dconf settings for all custom keybindings
  mapAllCustomBindings = index: customBindings: 
    if customBindings == [] then []
    else
      [ (mapCustomBinding index (head customBindings)) ] ++ (mapAllCustomBindings (index + 1) (tail customBindings));
  # we need to register each custom binding path so that it is included in the final dconf settings
  registerCustomBindingNames = customBindings: {
    "${customBindingPathBase}" = genList (i: "/${customBindingPath i}/") (length customBindings);
  };
  # process the custom bindings
  processCustomBindings = customBindings: 
    listToAttrs (mapAllCustomBindings 0 customBindings) // registerCustomBindingNames customBindings;

  numOfDesktops = 9;
in
  {
    # we need the desktops to exist
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      num-workspaces = numOfDesktops;
    };
    # set the keybindings
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
      move-to-workspace-7 = ["<Super><Shift>7"];
      move-to-workspace-8 = ["<Super><Shift>8"];
      move-to-workspace-9 = ["<Super><Shift>9"];

      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-8 = ["<Super>8"];
      switch-to-workspace-9 = ["<Super>9"];
    };
    # and we need to disable the keybindings that conflict with our custom
    # keybindings 
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };
  } 
