{ ... }: {
  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb = { };
        };
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
        mouse = {
          accel-speed = 0.0;
        };
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = { proportion = 1.0 / 2.0; };
        focus-ring = {
          width = 2;
          active.color = "#33ccff";
          inactive.color = "#595959";
        };
        border = {
          enable = false;
        };
      };

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "swww-daemon" ]; }
        { command = [ "wallpaper-cycle" ]; }
        { command = [ "xwayland-satellite" ]; }
      ];

      prefer-no-csd = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      binds = let
        terminal = "ghostty";
        fileManager = "files";
        menu = "walker";
      in {
        # Application launchers
        "Mod+Ctrl+Alt+Return".action.spawn = terminal;
        "Mod+Ctrl+Alt+E".action.spawn = fileManager;
        "Mod+Space".action.spawn = menu;

        # Session management
        "Mod+Ctrl+Alt+Shift+Q".action.quit = { };
        "Mod+Ctrl+Alt+Shift+R".action.power-off-monitors = { };

        # Window management
        "Mod+Q".action.close-window = { };
        "Mod+Ctrl+Alt+V".action.toggle-window-floating = { };
        "Mod+Ctrl+Alt+W".action.maximize-column = { };
        "Mod+Ctrl+Alt+F".action.fullscreen-window = { };

        # Focus management
        "Mod+Ctrl+Alt+Left".action.focus-column-left = { };
        "Mod+Ctrl+Alt+Right".action.focus-column-right = { };
        "Mod+Ctrl+Alt+Up".action.focus-window-up = { };
        "Mod+Ctrl+Alt+Down".action.focus-window-down = { };

        # Move windows
        "Mod+Ctrl+Alt+Shift+Left".action.move-column-left = { };
        "Mod+Ctrl+Alt+Shift+Right".action.move-column-right = { };
        "Mod+Ctrl+Alt+Shift+Up".action.move-window-up = { };
        "Mod+Ctrl+Alt+Shift+Down".action.move-window-down = { };

        # Column width adjustments
        "Mod+Ctrl+Alt+Minus".action.set-column-width = "-10%";
        "Mod+Ctrl+Alt+Equal".action.set-column-width = "+10%";

        # Workspace management
        "Mod+Ctrl+Alt+1".action.focus-workspace = 1;
        "Mod+Ctrl+Alt+2".action.focus-workspace = 2;
        "Mod+Ctrl+Alt+3".action.focus-workspace = 3;
        "Mod+Ctrl+Alt+4".action.focus-workspace = 4;
        "Mod+Ctrl+Alt+5".action.focus-workspace = 5;
        "Mod+Ctrl+Alt+6".action.focus-workspace = 6;
        "Mod+Ctrl+Alt+7".action.focus-workspace = 7;
        "Mod+Ctrl+Alt+8".action.focus-workspace = 8;
        "Mod+Ctrl+Alt+9".action.focus-workspace = 9;
        "Mod+Ctrl+Alt+0".action.focus-workspace = 10;

        # Move window to workspace
        "Mod+Ctrl+Alt+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+Alt+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+Alt+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+Alt+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+Alt+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+Alt+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+Alt+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+Alt+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+Alt+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Ctrl+Alt+Shift+0".action.move-column-to-workspace = 10;

        # Scroll through workspaces
        "Mod+Ctrl+Alt+Page_Down".action.focus-workspace-down = { };
        "Mod+Ctrl+Alt+Page_Up".action.focus-workspace-up = { };

        # Consume/expel windows from columns
        "Mod+Ctrl+Alt+BracketLeft".action.consume-window-into-column = { };
        "Mod+Ctrl+Alt+BracketRight".action.expel-window-from-column = { };

        # Screenshots
        "Mod+S".action.screenshot = { };
        "Mod+Shift+S".action.screenshot-screen = { };
        "Mod+Ctrl+S".action.screenshot-window = { };

        # Mouse bindings
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = { };
        };
      };

      window-rules = [
        {
          matches = [{ app-id = "^org\\.gnome\\."; }];
          draw-border-with-background = false;
        }
      ];
    };
  };
}
