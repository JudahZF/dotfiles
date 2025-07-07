{ inputs, outputs, config, lib, hostname, system, username, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  system.defaults.CustomUserPreferences = {
    "com.apphousekitchen.aldente-pro.plist" = {
      chargeVal = 80;
      dataShareConsent = false;
      exitInhibitCharge = false;
      heatProtectMode = true;
      launchAtLogin = true;
      magsafeBlinkDischarge = true;
      magsafeControl = true;
      maxTemperature = 40;
      menuBarIconStyle = -1;
      menubarRightClickAction = 2;
      noMenubarIcon = false;
      popoverAnimation = false;
      popoverWidgets = [
        "highAppUsage"
        "powerflow"
      ];
      sailingMode = true;
      showDockIcon = false;
      showGUIonStartup = false;
      showPercentage = true;
      showPercentagePopover = true;
      sleepInhibitCharge = true;
      useRealPercentage = true;
    };
    "com.apple.finder" = {
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      DisableAllAnimations = true;
      FK_ArrangeBy = "Date Added";
      FK_SidebarWidth = 128;
      FK_StandardViewOptions.ColumnViewOptions = {
        ArrangeBy = "dnam";
        ColumnShowFolderArrow = true;
        ColumnShowIcons = true;
        ColumnWidth = 245;
        ShowIconThumbnails = true;
        ShowPreview = true;
      };
      FK_StandardViewOptions2.ColumnViewOptions = {
        ArrangeBy = "dnam";
        ColumnShowFolderArrow = true;
        ColumnShowIcons = true;
        ColumnWidth = 245;
        ShowIconThumbnails = true;
        ShowPreview = true;
      };
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      NewWindowTarget = "PfDe";
      NewWindowTargetPath = "file://$\{HOME\}/";
      PreviewPaneGalleryWidth = 250;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowStatusBar = true;
      ShowPathbar = true;
      ShowRecentTags = false;
      SidebarWidth = 170;
      WarnOnEmptyTrash = false;
    };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.dock" = {
        autohide = false;
        launchanim = false;
        static-only = false;
        show-recents = false;
        show-process-indicators = true;
        orientation = "left";
        tilesize = 36;
        minimize-to-application = true;
        mineffect = "scale";
        enable-window-tool = false;
      };
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      "com.apple.Safari" = {
        # Privacy: don’t send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
      "com.googlecode.iterm2".PromptOnQuit = false;
      "com.google.Chrome" = {
        AppleEnableSwipeNavigateWithScrolls = true;
        DisablePrintPreview = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
  };
}
