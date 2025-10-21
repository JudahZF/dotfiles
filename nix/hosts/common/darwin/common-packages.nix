{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "chrome-cli"
      "cocoapods"
      "FiloSottile/musl-cross/musl-cross"
      "macmon"
      "mas"
      {
        name = "sketchybar";
        start_service = true;
        restart_service = true;
      }
      {
        name = "jackielii/tap/skhd-zig";
      }
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
      "betterdisplay"
      "comfyui"
      "cursor"
      "daisydisk"
      "dante-controller"
      "datagrip"
      "displaperture"
      "dropbox"
      "docker-desktop"
      "ghostty"
      "google-chrome"
      "hiddenbar"
      "hyperkey"
      "keka"
      "malwarebytes"
      "microsoft-office"
      "microsoft-teams"
      "nomachine"
      # "onyx"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "quicklookase"
      "raycast"
      "raspberry-pi-imager"
      "rockboxutility"
      "silicon-labs-vcp-driver"
      "sketch"
      "stats"
      "tailscale-app"
      "tor-browser"
      "utm"
      "vlc"
      "whatsapp"
      "wireshark"
      "wifiman"
      "zen"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Capo" = 696977615;
      "Home Assistant Companion" = 1099568401;
      "Windows App" = 1295203466;
      "Logic Pro" = 634148309;
      "Xcode" = 497799835;
    };
    taps = [
      "FelixKratz/formulae"
      "filosottile/musl-cross"
      "koekeishiya/formulae"
    ];
  };
  environment.systemPackages = [ pkgs.mkalias ];
}
