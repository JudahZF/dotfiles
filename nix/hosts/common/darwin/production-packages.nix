{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  homebrew = {
    casks = [
      "4k-video-downloader"
      "ableset"
      "ableton-live-suite"
      "companion@beta"
      "lightkey"
      "midi-monitor"
      "propresenter"
    ];
    taps = [
	    "bevanjkay/homebrew-tap"
    ];
  };
}
