{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = [ pkgs.btrfs-progs ];

  services.fstrim.enable = true;
}
