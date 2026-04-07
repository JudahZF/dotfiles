{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  security.pam.services.sudo_local.touchIdAuth = true;
}
