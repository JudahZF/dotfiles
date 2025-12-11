{ ... }: {
  boot.kernelModules = [ "drivetemp" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernelParams = [ "i915.fastboot=1" "i915.enable_guc=3" ];
}
