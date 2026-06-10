{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.casks = [ "raspberry-pi-imager" ];
}
