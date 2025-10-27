{ ... }: {
  system.defaults = {
    dock = {
      appswitcher-all-displays = true;
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      dashboard-in-overlay = false;
      enable-spring-load-actions-on-all-items = false;
      expose-animation-duration = 0.1;
      expose-group-apps = false;
      largesize = 16;
      launchanim = false;
      magnification = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = false;
      mru-spaces = false;
      orientation = "right";
      persistent-others = [ ];
      show-process-indicators = true;
      show-recents = false;
      showhidden = false;
      slow-motion-allowed = false;
      static-only = false;
      tilesize = 48;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 12;
    };
    finder = {
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    loginwindow = {
      autoLoginUser = null;
      DisableConsoleAccess = true;
      GuestEnabled = false;
      LoginwindowText = "Property of Judah Fuller";
      PowerOffDisabledWhileLoggedIn = false;
      RestartDisabled = false;
      RestartDisabledWhileLoggedIn = false;
      SHOWFULLNAME = false;
      ShutDownDisabled = true;
      ShutDownDisabledWhileLoggedIn = false;
      SleepDisabled = false;
    };
    magicmouse.MouseButtonMode = "TwoButton";
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = true;
      ShowAMPM = false;
      ShowDate = 0;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };
    screencapture = {
      disable-shadow = false;
      location = "~/Pictures/Screen Captures/";
      show-thumbnail = true;
      type = "png";
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 30;
    };
    spaces.spans-displays = false;
    trackpad = {
      ActuationStrength = 1;
      Clicking = false;
      Dragging = false;
      FirstClickThreshold = 1;
      SecondClickThreshold = 2;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 0;
    };
    LaunchServices.LSQuarantine = false;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      InitialKeyRepeat = 25;
      KeyRepeat = 2;
      NSUseAnimatedFocusRing = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSWindowShouldDragOnGesture = true;
      NSAutomaticSpellingCorrectionEnabled = false;
      "com.apple.mouse.tapBehavior" = 1;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
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
