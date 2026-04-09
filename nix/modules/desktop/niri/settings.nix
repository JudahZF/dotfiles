{ lib }:
let
  mkOutput =
    {
      name,
      mode,
      x,
      y,
      scale ? 1,
    }:
    ''
      output "${name}" {
          mode "${mode}"
          position x=${toString x} y=${toString y}
          scale ${toString scale}
      }
    '';
in
{
  host,
  outputs,
  noctaliaPackage,
}:
let
  noctaliaExe = lib.getExe noctaliaPackage;
in
''
  input {
      keyboard {
          numlock
      }

      touchpad {
          tap
          natural-scroll
      }
  }

  ${lib.concatMapStringsSep "\n" mkOutput outputs}

  layout {
      gaps 4
      default-column-width { proportion 0.5; }
      focus-ring {
          width 2
          active-color "#33ccff"
          inactive-color "#595959"
      }
      border {
          off
      }
      shadow {
          on
          softness 24
          spread 4
          offset x=0 y=4
          color "#00000033"
      }
  }

  hotkey-overlay {
      skip-at-startup
  }

  prefer-no-csd
  screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

  spawn-at-startup "${noctaliaExe}" "--no-duplicate"
  spawn-at-startup "swww-daemon"
  spawn-sh-at-startup "sleep 1 && wallpaper-cycle"

  window-rule {
      clip-to-geometry true
      geometry-corner-radius 10
  }

  layer-rule {
      match namespace="^noctalia-wallpaper-.*$"
      place-within-backdrop true
  }

  binds {
      Mod+Space { spawn "${noctaliaExe}" "ipc" "call" "launcher" "toggle"; }
      Mod+S { spawn "${noctaliaExe}" "ipc" "call" "controlCenter" "toggle"; }
      Mod+Comma { spawn "${noctaliaExe}" "ipc" "call" "settings" "toggle"; }

      Mod+Return { spawn "ghostty"; }
      Mod+E { spawn "files"; }

      Mod+Q { close-window; }
      Mod+Shift+Q { quit; }
      Mod+V { toggle-window-floating; }
      Mod+W { fullscreen-window; }

      Mod+Left { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up { focus-window-up; }
      Mod+Down { focus-window-down; }

      Mod+Ctrl+Left { move-column-left; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+Up { move-window-up; }
      Mod+Ctrl+Down { move-window-down; }

      Mod+Shift+Left { focus-monitor-left; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+0 { focus-workspace 10; }

      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }
      Mod+Shift+0 { move-column-to-workspace 10; }

      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }

      Print { screenshot; }
      Mod+Shift+S { spawn-sh "grim -g \"$(slurp)\""; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
  }
''
