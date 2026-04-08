{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [ "game-porting-toolkit" ];
    taps = [ "Gcenx/homebrew-wine" ];
  };
}
