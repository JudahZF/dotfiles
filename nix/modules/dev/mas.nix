{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.brews = [ "mas" ];
}
