{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  boot.kernelModules = ["drivetemp"];
  boot.kernelParams = ["usbcore.autosuspend=300"];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
