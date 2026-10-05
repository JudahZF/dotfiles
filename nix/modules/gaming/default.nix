{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      "curseforge"
      {
        name = "gcenx/wine/game-porting-toolkit";
        trusted = true;
      }
      "minecraft"
    ];
    brews = [ "samtay/tui/tetris" ];
  };
}
