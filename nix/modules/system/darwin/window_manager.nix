{ pkgs, lib, username, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.activationScripts.cleanupLegacySkhd.text = ''
    legacy_skhd_plist="/Users/${username}/Library/LaunchAgents/com.koekeishiya.skhd.plist"
    if [ -f "$legacy_skhd_plist" ]; then
      echo "removing legacy koekeishiya skhd launch agent..." >&2
      uid="$(id -u ${username})"
      /bin/launchctl bootout "gui/$uid/com.koekeishiya.skhd" >/dev/null 2>&1 || true
      rm -f "$legacy_skhd_plist"
    fi
  '';

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowScrollBars = "Always";
      NSWindowShouldDragOnGesture = true;
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 30;
    };
    spaces.spans-displays = false;
    WindowManager = {
      AppWindowGroupingBehavior = false;
      AutoHide = true;
      EnableStandardClickToShowDesktop = true;
      GloballyEnabled = false;
      HideDesktop = false;
      StageManagerHideWidgets = true;
      StandardHideDesktopIcons = false;
      StandardHideWidgets = true;
    };
  };

  # Yabai window manager service (managed by nix-darwin instead of homebrew)
  launchd.user.agents.yabai = {
    serviceConfig = {
      Label = "com.koekeishiya.yabai";
      ProgramArguments = [ "/opt/homebrew/bin/yabai" ];
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      StandardOutPath = "/tmp/yabai_${username}.out.log";
      StandardErrorPath = "/tmp/yabai_${username}.err.log";
      ProcessType = "Interactive";
      Nice = -20;
    };
  };

  # skhd hotkey daemon service (managed by nix-darwin instead of homebrew)
  launchd.user.agents.skhd = {
    serviceConfig = {
      Label = "com.jackielii.skhd";
      ProgramArguments =
        [ "/opt/homebrew/opt/skhd-zig/bin/skhd" "-c" "/Users/${username}/.skhdrc" ];
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      StandardOutPath = "/tmp/skhd_${username}.out.log";
      StandardErrorPath = "/tmp/skhd_${username}.err.log";
      ProcessType = "Interactive";
      Nice = -20;
    };
  };
}
