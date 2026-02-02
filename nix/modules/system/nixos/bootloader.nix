{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
