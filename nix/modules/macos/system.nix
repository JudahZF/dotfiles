{
    config,
    pkgs,
    ...
}: {
    homebrew = {
        enable = true;
        brews = [
	"chrome-cli"
            "cmatrix"
            "macmon"
            "mas"
            {
                name = "sketchybar";
                start_service = true;
                restart_service = true;
            }
            {
                name = "skhd";
            }
            "samtay/tui/tetris"
            {
                name = "yabai";
            }
        ];
        casks = [
            "1Password"
            "1password-cli"
            "aldente"
            "alt-tab"
            "altserver"
            "balenaetcher"
            "betterdisplay"
            "chromium"
			"daisydisk"
            "displaperture"
            "dropbox"
            "font-sketchybar-app-font"
	    "ghostty"
	"google-chrome"
            "hiddenbar"
            "keka"
	    "kicad"
            "legcord"
            "malwarebytes"
            "microsoft-office"
            "ollama"
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
            "tor-browser"
            "whatsapp"
            "wifiman"
            "zen-browser"
        ];
        masApps = {
            "Logic Pro" = 634148309;
        };

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
        taps = [
            "FelixKratz/formulae"
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
}
