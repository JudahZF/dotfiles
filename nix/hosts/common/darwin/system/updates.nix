{ ... }: {
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        ScheduleFrequency = 1;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
      };
      "com.apple.commerce".AutoUpdate = true;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };
}
