{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    # Common homebrew packages
    brews = [
      "azure-cli"
      # "chrome-cli" # removed - no longer using Chrome
      "cocoapods"
      "FiloSottile/musl-cross/musl-cross"
      "withgraphite/tap/graphite"
      "macmon"
      "mas"
      "jackielii/tap/skhd-zig"
      "samtay/tui/tetris"
      {
        name = "yabai";
        args = [ "--HEAD" ];
      }
    ];
    casks = [
      "1password"
      "aldente"
      "alt-tab"
      "angry-ip-scanner"
      "balenaetcher"
      "barrier"
      "bartender"
      "betterdisplay"
      "codex"
      "comfyui"
      "daisydisk"
      "dante-controller"
      "datagrip"
      "displaperture"
      "dropbox"
      "docker-desktop"
      "game-porting-toolkit"
      "ghostty"
      # "helium-browser" # now managed via nix flake
      "hiddenbar"
      "hyperkey"
      "iina"
      "keka"
      "lm-studio"
      "malwarebytes"
      # "microsoft-edge" # removed - only using helium + zen
      "microsoft-office"
      "microsoft-teams"
      "mqttx"
      "nomachine"
      "private-internet-access"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "quicklookase"
      "raycast"
      "raspberry-pi-imager"
      "rockboxutility"
      "signal"
      "silicon-labs-vcp-driver"
      "sketch"
      "stats"
      "codex-app"
      "steipete/tap/codexbar"
      "tailscale-app"
      # "tor-browser" # removed - only using helium + zen
      "vlc"
      "whatsapp"
      "wireshark-app"
      "unifi-identity-endpoint"
      "utm"
      "wifiman"
      "wispr-flow"
      "zen"
      # Design
      "affinity"
      "autodesk-fusion"
      "gimp"
      "kicad"
      "pika"
      "orcaslicer"
      # Gaming
      "curseforge"
      "minecraft"
      "steam"
      # Music production
      "ableton-live-suite"
      "arturia-software-center"
      "blackhole-64ch"
      "ilok-license-manager"
      "midi-monitor"
      "native-access"
      "qlab"
      "waves-central"
      # Production
      "4k-video-downloader"
      "ableset"
      "companion"
      "handbrake-app"
      "lightkey"
      "ndi-tools"
      "propresenter"
      "resolume-arena"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Capo" = 696977615;
      "Home Assistant Companion" = 1099568401;
      "Xcode" = 497799835;
      "Final Cut Pro" = 424389933;
    };
    taps = [
      "FelixKratz/formulae"
      "filosottile/musl-cross"
      "Gcenx/homebrew-wine"
      "jackielii/tap"
      "koekeishiya/formulae"
      "steipete/tap"
      "withgraphite/tap"
      "bevanjkay/homebrew-tap"
    ];
  };
}
