{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    brews = [ "macmon" ];
    taps = [ "FelixKratz/formulae" ];
  };
}
