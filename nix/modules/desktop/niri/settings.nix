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

      focus-follows-mouse
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

      Mod+Shift+Left { focus-monitor-left; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+1 { move-workspace-to-monitor-left; }
      Mod+Shift+Ctrl+2 { move-workspace-to-monitor-right; }

      Mod+WheelScrollRight cooldown-ms=150 { focus-column-right; }
      Mod+WheelScrollLeft cooldown-ms=150 { focus-column-left; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-column-right; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-column-left; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { reset-window-height; }
      Mod+F { maximize-column; }

      Mod+Page_Down { focus-workspace-down; }
      Mod+Page_Up { focus-workspace-up; }
      Mod+Ctrl+Page_Down { move-window-down-or-to-workspace-down; }
      Mod+Ctrl+Page_Up { move-window-up-or-to-workspace-up; }

      Print { screenshot; }
      Mod+Shift+S { spawn-sh "grim -g \"$(slurp)\""; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
  }
''
