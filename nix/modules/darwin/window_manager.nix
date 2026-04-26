{
  pkgs,
  lib,
  username,
  ...
}:
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
}
