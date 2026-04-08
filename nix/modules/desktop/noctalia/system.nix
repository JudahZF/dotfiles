{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
