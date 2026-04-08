{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.fwupd.enable = true;
}
