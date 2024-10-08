{
    config,
    lib,
    pkgs,
    ...
}: {
    homebrew = {
        enable = true;
        brews = [
            "mas"
        ];
        casks = [
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
            "onedrive"
            "onyx"
            "qlcolorcode"
            "qlimagesize"
            "qlmarkdown"
            "qlstephen"
            "qlvideo"
            "quicklook-json"
            "quicklookase"
            "raycast"
            "rockboxutility"
            "sketchybar"
            "stats"
            "ukelele"
            "yabai"
        ];
        masApps = {
            "Amphetamine" ="937984704";
            "Encrypto" = "935235287";
            "Home Assistant" = "1099568401";
            "Mactracker" = "430255202";
            "Sonicwall Mobile Connect" = "822514576";
        };
        onActivation.cleanup = "zap";
        taps = {
            homebrew-core = "homebrew/homebrew-core";
            homebrew-cask = "homebrew/homebrew-cask";
            FelixKratz = "FelixKratz/formulae";
        };
        brews.sketchybar.start_service = true;
        brews.yabai.start_service = true;
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
        while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
    '';

    system.defaults = {
        dock.autohide  = true;
        dock.largesize = 64;
        dock.orientation = "right";
        dock.persistent-apps = [
            "/Applications/Arc.app"
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/1Password.app"
        ];
        finder.AppleShowAllExtensions = true;
        finder.AppleShowAllFiles = true;
        finder.FXPreferredViewStyle = "clmv";
        finder.QuitMenuItem = true;
        finder.showpathbar = true;
        finder.ShowStatusBar = true;
        loginwindow.GuestEnabled  = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
        screencapture.type = "png";
        spaces.spans-displays = true;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
}
