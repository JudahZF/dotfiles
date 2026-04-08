{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    casks = [ "wispr-flow" ];
    taps = [ "bevanjkay/homebrew-tap" ];
  };
}
