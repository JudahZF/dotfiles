{ pkgs, lib, ... }:
# Only enable systemd-boot on x86_64 Linux (RPi5 uses its own bootloader via nixos-hardware)
lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64) {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
