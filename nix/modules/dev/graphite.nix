{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    brews = [ "withgraphite/tap/graphite" ];
    taps = [ "withgraphite/tap" ];
  };
}
