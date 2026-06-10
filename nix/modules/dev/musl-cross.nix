{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew = {
    brews = [ "FiloSottile/musl-cross/musl-cross" ];
  };
}
