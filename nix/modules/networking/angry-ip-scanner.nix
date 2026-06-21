{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [ "angry-ip-scanner" ];
}
