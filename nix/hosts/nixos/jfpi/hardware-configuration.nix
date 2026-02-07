{ lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # RPi5 boot is handled by nixos-hardware module

  # Filesystem - Ubuntu's existing partition labels
  fileSystems."/" = {
    device = "/dev/disk/by-label/writable";
    fsType = "ext4";
  };
  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-label/system-boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
