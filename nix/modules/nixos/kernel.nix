{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  boot = {
    kernelModules = [ "drivetemp" ];
    kernelParams = [ "usbcore.autosuspend=300" ];
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };
}
