{ ... }:
{
  homebrew = {
    brews = [
      "chrome-cli"
      "FiloSottile/musl-cross/musl-cross"
      "macmon"
      "mas"
      {
        name = "sketchybar";
        start_service = true;
        restart_service = true;
      }
      { name = "skhd"; }
      "samtay/tui/tetris"
      { name = "yabai"; }
    ];
    casks = [
      "1password"
      "aldente"
      "alt-tab"
      "angry-ip-scanner"
      "balenaetcher"
      "betterdisplay"
      "comfyui"
      "daisydisk"
      "dante-controller"
      "displaperture"
      "dropbox"
      "docker-desktop"
      "ghostty"
      "hiddenbar"
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
      "sketch"
      "stats"
      "tailscale"
      "tor-browser"
      "whatsapp"
      "wifiman"
      "zen"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Home Assistant Companion" = 1099568401;
      "Windows App" = 1295203466;
      "Logic Pro" = 634148309;
    };
    taps = [
      "FelixKratz/formulae"
      "filosottile/musl-cross"
      "koekeishiya/formulae"
    ];
  };
}
