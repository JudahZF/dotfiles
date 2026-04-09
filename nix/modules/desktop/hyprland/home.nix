{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$hyprMod" = "SUPER CTRL ALT";
      "$cmdMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "files";
      "$ipc" = "noctalia-shell ipc call";

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
        "$cmdMod SHIFT, r, exec, hyprctl, reload"
        "$cmdMod SHIFT, q, exit"
        ''$cmdMod SHIFT, S, exec, grim -g "$(slurp)"''

        # application launchers
        "$cmdMod, RETURN, exec, $terminal"
        "$cmdMod, E, exec, $fileManager"
        "$cmdMod, SPACE, exec, $ipc launcher toggle"
        "$cmdMod, S, exec, $ipc controlCenter toggle"
        "$cmdMod, comma, exec, $ipc settings toggle"

        # window management
        "$cmdMod, Q, killactive"
        "$cmdMod, V, togglefloating"
        "$cmdMod, W, fullscreen"
        "$cmdMod, J, togglesplit"

        # focus management
        "$cmdMod, LEFT, movefocus, l"
        "$cmdMod, RIGHT, movefocus, r"
        "$cmdMod, UP, movefocus, u"
        "$cmdMod, DOWN, movefocus, d"
        "$cmdMod SHIFT, LEFT, movetoworkspace, r-1"
        "$cmdMod SHIFT, RIGHT, movetoworkspace, r+1"

        # workspace management
        ## switch to workspace
        "$cmdMod, 1, workspace, 1"
        "$cmdMod, 2, workspace, 2"
        "$cmdMod, 3, workspace, 3"
        "$cmdMod, 4, workspace, 4"
        "$cmdMod, 5, workspace, 5"
        "$cmdMod, 6, workspace, 6"
        "$cmdMod, 7, workspace, 7"
        "$cmdMod, 8, workspace, 8"
        "$cmdMod, 9, workspace, 9"
        "$cmdMod, 0, workspace, 10"

        ## move window to workspace
        "$cmdMod SHIFT, 1, movetoworkspace, 1"
        "$cmdMod SHIFT, 2, movetoworkspace, 2"
        "$cmdMod SHIFT, 3, movetoworkspace, 3"
        "$cmdMod SHIFT, 4, movetoworkspace, 4"
        "$cmdMod SHIFT, 5, movetoworkspace, 5"
        "$cmdMod SHIFT, 6, movetoworkspace, 6"
        "$cmdMod SHIFT, 7, movetoworkspace, 7"
        "$cmdMod SHIFT, 8, movetoworkspace, 8"
        "$cmdMod SHIFT, 9, movetoworkspace, 9"
        "$cmdMod SHIFT, 0, movetoworkspace, 10"

        ## scroll through workspaces
        "$cmdMod, mouse_down, workspace, e+1"
        "$cmdMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$cmdMod, mouse:272, movewindow"
        "$cmdMod, mouse:273, resizewindow"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        rounding = 10;
      };

      exec-once = [
        "noctalia-shell --no-duplicate"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 4;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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
  };
}
