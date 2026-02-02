{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.defaults = {
    CustomUserPreferences = {
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
        NewWindowTargetPath = "file://\${HOME}/";
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
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
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
  };
}
