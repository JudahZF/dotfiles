{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "qlcolorcode"
    "qlmarkdown"
    "qlstephen"
    "quicklook-video"
    "quicklook-json"
    "quicklookase"
  ];
}
