{ ... }: {
  wayland.windowManager.hyprland.settings = {
    "$hyprMod" = "SUPER CTRL ALT";
    "$terminal" = "ghostty";
    "$fileManager" = "files";
    "$menu" = "walker";

    animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "windows, 1, 7, myBezier"
          "fade, 1, 7, default"
          "windowsOut, 1, 7, default, popin 80%"
          "workspaces, 1, 6, default"
        ];
    };

    bind = [
      # session management
      "$hyprMod SHIFT, r, reload"
      "$hyprMod SHIFT, q, exit"
      "SUPER, S, exec, grim -g \"$(slurp)\""

      # application launchers
      "$hyprMod, RETURN, exec:$terminal"
      "$hyprMod, E, exec:$fileManager"
      "$hyprMod, SPACE, exec:$menu"

      # window management
      "$hyprMod, Q, killactive"
      "$hyprMod, V, togglefloating"
      "$hyprMod, W, fullscreen"
      "$hyprMod, J, togglesplit"

      # focus management
      "$hyprMod, LEFT, movefocus, l"
      "$hyprMod, RIGHT, movefocus, r"
      "$hyprMod, UP, movefocus, u"
      "$hyprMod, DOWN, movefocus, d"
      "$hyprMod, SHIFT, LEFT, movetoworkspaceprev"
      "$hyprMod, SHIFT, RIGHT, movetoworkspacenext"

      # workspace management
      ## switch to workspace
      "$hyprMod, 1, workspace, 1"
      "$hyprMod, 2, workspace, 2"
      "$hyprMod, 3, workspace, 3"
      "$hyprMod, 4, workspace, 4"
      "$hyprMod, 5, workspace, 5"
      "$hyprMod, 6, workspace, 6"
      "$hyprMod, 7, workspace, 7"
      "$hyprMod, 8, workspace, 8"
      "$hyprMod, 9, workspace, 9"
      "$hyprMod, 0, workspace, 10"

      ## move window to workspace
      "$hyprMod SHIFT, 1, workspace, 1"
      "$hyprMod SHIFT, 2, workspace, 2"
      "$hyprMod SHIFT, 3, workspace, 3"
      "$hyprMod SHIFT, 4, workspace, 4"
      "$hyprMod SHIFT, 5, workspace, 5"
      "$hyprMod SHIFT, 6, workspace, 6"
      "$hyprMod SHIFT, 7, workspace, 7"
      "$hyprMod SHIFT, 8, workspace, 8"
      "$hyprMod SHIFT, 9, workspace, 9"
      "$hyprMod SHIFT, 0, workspace, 10"

      ## scroll through workspaces
      "$hyprMod, mouse_down, workspace, e+1"
      "$hyprMod, mouse_up, workspace, e-1"
    ];

    bindm = [
      "$hyprMod, mouse:272, movewindow"
      "$hyprMod, mouse:273, resizewindow"
    ];

    decoration = {
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      rounding = 10;
    };

    exec-once = "waybar & hyprpaper";

    general = {
      gaps_in = 2;
      gaps_out = 4;
      border_size = 2;
      col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      col.inactive_border = "rgba(595959aa)";
      layout = "dwindle";
      allow_tearing = false;
    };

    "windowrulev2" = "suppressevent maximize, class:.*";

    workspace = [
      "1,name:helium"
      "2,name:zed"
      "3,name:1password"
      "4,name:terminal"
      "5,name:zen"
      "6,name:database"
      "7,name:git"
      "8,name:remote"
      "9,name:files"
      "10,name:stats"
    ];
  };
}
