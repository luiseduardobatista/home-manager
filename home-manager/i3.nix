{ config, pkgs, lib, ... }:

let
  wallpaper = builtins.fetchurl {
    url = "https://github.com/basecamp/omakub/raw/master/themes/catppuccin/background.png";
    sha256 = "0mwql59zkkylmb0l2wxnzb30ys5a7skbw3cgfzsvlbhv1wzdbib6";
  };
in
{

  home.packages = with pkgs; [
    polybar
    picom
    rofi
    lxappearance
    feh
    alacritty
  ];

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = "Mod4";
      floating.modifier = "Mod4";

      keybindings = {
        "Mod4+Shift+q" = "kill";
        "Mod4+h" = "focus left";
        "Mod4+j" = "focus down";
        "Mod4+k" = "focus up";
        "Mod4+l" = "focus right";
        "Mod4+Shift+h" = "move left";
        "Mod4+Shift+j" = "move down";
        "Mod4+Shift+k" = "move up";
        "Mod4+Shift+l" = "move right";
        "Mod4+v" = "split v";
        "Mod4+f" = "fullscreen toggle";
        "Mod4+Shift+space" = "floating toggle";

        # Workspace keybindings
        "Mod4+1" = "workspace number 1";
        "Mod4+2" = "workspace number 2";
        "Mod4+3" = "workspace number 3";
        "Mod4+4" = "workspace number 4";
        "Mod4+5" = "workspace number 5";
        "Mod4+6" = "workspace number 6";
        "Mod4+7" = "workspace number 7";
        "Mod4+8" = "workspace number 8";
        "Mod4+9" = "workspace number 9";
        "Mod4+0" = "workspace number 10";
        
        # Moving focused container to workspace
        "Mod4+Shift+1" = "move container to workspace number 1";
        "Mod4+Shift+2" = "move container to workspace number 2";
        "Mod4+Shift+3" = "move container to workspace number 3";
        "Mod4+Shift+4" = "move container to workspace number 4";
        "Mod4+Shift+5" = "move container to workspace number 5";
        "Mod4+Shift+6" = "move container to workspace number 6";
        "Mod4+Shift+7" = "move container to workspace number 7";
        "Mod4+Shift+8" = "move container to workspace number 8";
        "Mod4+Shift+9" = "move container to workspace number 9";
        "Mod4+Shift+0" = "move container to workspace number 10";

        # Reload and exit i3
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+e" = "exec \"i3-nagbar -t warning -m 'Você pressionou o atalho de saída. Realmente deseja sair do i3? Isso encerrará sua sessão X.' -B 'Sim, sair do i3' 'i3-msg exit'\"";
      };

      startup = [
        { command = "exec --no-startup-id picom"; always = true; notification = false; }
        { command = "exec --no-startup-id feh --bg-scale ${wallpaper}"; always = true; notification = true; }
        { command = "exec_always --no-startup-id xrdb -merge ~/.Xresources"; always = true; notification = false; }
        { command = "exec_always --no-startup-id setxkbmap -option ctrl:nocaps"; always = true; notification = false; }
        { command = "exec_always killall polybar"; always = true; notification = false; }
        { command = "exec_always --no-startup-id ~/.config/polybar/launch_polybar.sh"; always = true; notification = false; }
        { command = "exec --no-startup-id dex --autostart --environment i3"; always = true; notification = false; }
        { command = "exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork"; always = true; notification = false; }
        { command = "exec --no-startup-id nm-applet"; always = true; notification = false; }
      ];
    };


    extraConfig = ''
      for_window [class="^.*"] border pixel 1
      
      set $rosewater #f5e0dc
      set $flamingo  #f2cdcd
      set $pink      #f5c2e7
      set $mauve     #cba6f7
      set $red       #f38ba8
      set $maroon    #eba0ac
      set $peach     #fab387
      set $yellow    #f9e2af
      set $green     #a6e3a1
      set $teal      #94e2d5
      set $sky       #89dceb
      set $sapphire  #74c7ec
      set $blue      #89b4fa
      set $lavender  #b4befe
      set $text      #cdd6f4
      set $subtext1  #bac2de
      set $subtext0  #a6adc8
      set $overlay2  #9399b2
      set $overlay1  #7f849c
      set $overlay0  #6c7086
      set $surface2  #585b70
      set $surface1  #45475a
      set $surface0  #313244
      set $base      #1e1e2e
      set $mantle    #181825
      set $crust     #11111b
      
      client.focused           $mantle   $mauve $mantle  $rosewater $mauve
      client.focused_inactive  $overlay0 $base  $text    $rosewater $overlay0
      client.unfocused         $overlay0 $base  $text    $rosewater $overlay0
      client.urgent            $peach    $base  $peach   $overlay0  $peach
      client.placeholder       $overlay0 $base  $text    $overlay0  $overlay0
      client.background        $base
    '';
  };
}

