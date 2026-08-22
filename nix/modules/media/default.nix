{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      # Playback / general
      "iina"
      "vlc"
      "rockboxutility"

      # Audio production
      "ableton-live-suite"
      "ableset"
      "blackhole-64ch"
      "cycling74-max"
      "dante-controller"
      "midi-monitor"

      # Audio plugin managers
      "arturia-software-center"
      "ilok-license-manager"
      "native-access"
      "ua-connect"
      "waves-central"

      # Video production
      "4k-video-downloader"
      "handbrake-app"
      "ndi-tools"
      "propresenter"
      "resolume-arena"

      # Lighting / show control
      "lightkey"
      "companion"
      "qlab"
    ];

    masApps = {
      Capo = 696977615;
      "Final Cut Pro" = 424389933;
      "Logic Pro" = 634148309;
    };
  };

  # Apple Music: prefer lossless, leave volume untouched.
  system.defaults.CustomUserPreferences."com.apple.Music" = {
    losslessEnabled = true;
    optimizeSongVolume = false;
    preferredStreamPlaybackAudioQuality = 20;
  };
}
