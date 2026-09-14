{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      "alt-tab"
      "bartender"
      "betterdisplay"
      "bleunlock"
      "displaperture"
      "hiddenbar"
      "hyperkey"
      "openlogi"
      "stats"
      "TheBoredTeam/boring-notch/boring-notch"
    ];

    brews = [ "macmon" ];

    masApps = {
      Amphetamine = 937984704;
    };
  };
}
