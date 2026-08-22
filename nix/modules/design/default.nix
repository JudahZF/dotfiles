{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "affinity"
    "autodesk-fusion"
    "gimp"
    "kicad"
    "orcaslicer"
    "pika"
    "sketch"
  ];
}
