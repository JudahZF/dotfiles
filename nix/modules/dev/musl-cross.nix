{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    brews = [ "FiloSottile/musl-cross/musl-cross" ];
    taps = [ "filosottile/musl-cross" ];
  };
}
