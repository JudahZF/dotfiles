{ inputs, pkgs, config, ... }: {
  programs.zen-browser = {
    profiles = {
      "default" = {
          containersForce = true;
          containers = {
            Personal = {
              color = "blue";
              icon = "fingerprint";
              id = 1;
            };
            Work = {
              color = "orange";
              icon = "briefcase";
              id = 2;
            };
            "Work Admin" = {
              color = "red";
              icon = "briefcase";
              id = 3;
            };
            University = {
              color = "purple";
              icon = "briefcase";
              id = 4;
            };
          };
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            darkreader
            enhancer-for-nebula
            enhancer-for-youtube
            facebook-container
            languagetool
            onepassword-password-manager
            return-youtube-dislikes
            ublock-origin
          ];
          spacesForce = true;
          spaces = let
            containers = config.programs.zen-browser.profiles."default".containers;
          in {
            "Personal" = {
              id = "c6de089c-410d-4206-961d-ab11f988d40a";
              container = containers."Personal".id;
              position = 1000;
            };
            "Projects" = {
              id = "845d81a9-9c90-4792-8fe1-59eb53dc9a1c";
              container = containers."Personal".id;
              position = 2000;
            };
            "Work" = {
              id = "cdd10fab-4fc5-494b-9041-325e5759195b";
              container = containers."Work".id;
              position = 3000;
            };
            "University" = {
              id = "2d89feb2-c9f9-408e-9997-d13529817b22";
              container = containers."University".id;
              position = 4000;
            };
          };
      };
  };
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BlockAboutProfiles = true;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Homepage = "https://inpressplastics.sharepoint.com";
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      SearchEngines = {
        Default = "DuckDuckGo";
        Custom = [
          {
            Name = "DuckDuckGo";
            Template = "https://duckduckgo.com/?q={searchTerms}";
            IconURL = "https://duckduckgo.com/favicon.ico";
            IsDefault = true;
          }
        ];
      };
      SkipTermsOfUse = true;
      TranslateEnabled = true;
    };
  };
}
