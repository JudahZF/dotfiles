{ ... }: {
  homebrew = {
    casks = [
      "4k-video-downloader"
      "ableset"
      "ableton-live-suite"
      "companion"
      "handbrake"
      "lightkey"
      "midi-monitor"
      "ndi-tools"
      "propresenter"
      "resolume-arena"
    ];
    masApps = { "Final Cut Pro" = 424389933; };
    taps = [ "bevanjkay/homebrew-tap" ];
  };
}
