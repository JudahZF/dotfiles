{
    config,
    pkgs,
    ...
}: {
    nixpkgs.hostPlatform = "aarch64-darwin";
    homebrew = {
        enable = true;
        brews = [
            "cmatrix"
            "mas"
            {
                name = "sketchybar";
                start_service = true;
                restart_service = true;
            }
            {
                name = "yabai";
                start_service = true;
                restart_service = true;
            }
        ];
        casks = [
            "1Password"
            "adobe-acrobat-reader"
            "aldente"
            "alt-tab"
            "arc"
            "balenaetcher"
            "betterdisplay"
            "cheatsheet"
            "daisydisk"
            "displaperture"
            "dropbox"
            "hiddenbar"
            "keka"
            "malwarebytes"
            "microsoft-office"
            "onyx"
            "qlcolorcode"
            "qlmarkdown"
            "qlstephen"
            "qlvideo"
            "quicklook-json"
            "quicklookase"
            "raycast"
            "raspberry-pi-imager"
            "rockboxutility"
            "stats"
            "tailscale"
            "zed"
        ];
        masApps = {
            "Amphetamine" = 937984704;
            "Encrypto" = 935235287;
            "Home Assistant" = 1099568401;
            "Mactracker" = 430255202;
        };
        onActivation.cleanup = "zap";
        taps = [
            "FelixKratz/formulae"
            "homebrew/homebrew-services"
            "koekeishiya/formulae"
        ];
    };

    system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
    };
    in
    pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
    '';

    system.defaults = {
        dock = {
            appswitcher-all-displays = true;
            autohide = true;
            autohide-delay = 0.0;
            autohide-time-modifier = 0.0;
            dashboard-in-overlay = false;
            enable-spring-load-actions-on-all-items = false;
            expose-animation-duration = 0.1;
            expose-group-by-app = false;
            largesize = 16;
            launchanim = false;
            magnification = false;
            mineffect = "scale";
            minimize-to-application = true;
            mouse-over-hilite-stack = false;
            mru-spaces = false;
            orientation = "right";
            persistent-apps = [
                "/Applications/Arc.app"
                "${pkgs.alacritty}/Applications/Alacritty.app"
                "${pkgs.obsidian}/Applications/Obsidian.app"
                "/System/Applications/Mail.app"
                "/System/Applications/Calendar.app"
                "/Applications/1Password.app"
            ];
            persistent-others = [];
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
        LaunchServices = {
            LSQuarantine = false;
        };
        loginwindow = {
            autoLoginUser = null;
            DisableConsoleAccess = true;
            GuestEnabled  = false;
            LoginwindowText = "Judah Fuller\'s M1 MBA";
            PowerOffDisabledWhileLoggedIn = false;
            RestartDisabled = false;
            RestartDisabledWhileLoggedIn = false;
            SHOWFULLNAME = false;
            ShutDownDisabled = true;
            ShutDownDisabledWhileLoggedIn = true;
            SleepDisabled = false;
        };
        magicmouse = {
            MouseButtonMode = "TwoButton";
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
        NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            KeyRepeat = 2;
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
        SoftwareUpdate = {
            AutomaticallyInstallMacOSUpdates = false;
        };
        spaces = {
            spans-displays = false;
        };
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
    system.stateVersion = 5;
    users.users.judahfuller.home = "/Users/judahfuller";
}
