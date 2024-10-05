{ config, lib, pkgs, ... }:

let
  popOsKeybindings = import ./pop-os-keybindings.nix;
  customKeyBindings = import ./custom-keybindings.nix;
in
  {
    home.packages = with pkgs; [
        bibata-cursors
        wmctrl
        gnomeExtensions.pop-shell
    ];

    dconf.settings = lib.recursiveUpdate
      customKeyBindings popOsKeybindings;
  }
