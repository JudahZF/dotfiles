# Thrustmaster racing wheel support with force feedback
# Supports T300RS, T248, T128, TX, TS-XW, TS-PC and similar wheels
{ config, pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  boot.blacklistedKernelModules = [ "hid-thrustmaster" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.hid-tmff2 ];
  boot.kernelModules = [ "hid-tmff2" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="044f", MODE="0660", GROUP="input"
  '';
}
