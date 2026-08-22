{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [
      "curseforge"
      "game-porting-toolkit"
      "minecraft"
    ];
    brews = [ "samtay/tui/tetris" ];
  };
}
