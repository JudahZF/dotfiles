{ pkgs, lib, username, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
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
}
