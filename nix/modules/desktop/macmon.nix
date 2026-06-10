{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew = {
    brews = [ "macmon" ];
  };
}
