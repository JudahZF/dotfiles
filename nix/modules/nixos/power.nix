{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = [ pkgs.powertop ];
  powerManagement.powertop.enable = true;
}
