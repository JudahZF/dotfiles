{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.casks = [
    "ableton-live-suite"
    "cycling74-max"
  ];
}
