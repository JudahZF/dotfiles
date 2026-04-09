{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  hardware.firmware = [ pkgs.linux-firmware ];
}
