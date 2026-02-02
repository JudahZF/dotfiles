{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  networking = {
    firewall.enable = false;
  };
}
