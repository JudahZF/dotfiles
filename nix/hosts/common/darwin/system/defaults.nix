{ ... }: {
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.AdLib" = {
        allowIdentifierForAdvertising = false;
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.ImageCapture".disableHotPlug = true;
    };
    menuExtraClock = {
      IsAnalog = false;
      Show24Hour = true;
      ShowAMPM = false;
      ShowDate = 0;
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };
    LaunchServices.LSQuarantine = false;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleShowAllExtensions = true;
      NSUseAnimatedFocusRing = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };
}
