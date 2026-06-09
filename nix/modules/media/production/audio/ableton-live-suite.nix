{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "ableton-live-suite"
    "cycling74-max"
  ];
}
