{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      "daisydisk"
      "dropbox"
      "granola"
      "keka"
      "microsoft-office"
      "microsoft-teams"
      "notion"
      "wispr-flow"

      # QuickLook generators
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "quicklook-video"
      "quicklook-json"
      "quicklookase"
    ];

    masApps = {
      "Home Assistant Companion" = 1099568401;
      Numbers = 361304891;
    };
  };
}
