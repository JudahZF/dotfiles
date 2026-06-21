{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [ "unifi-identity-endpoint" ];
}
