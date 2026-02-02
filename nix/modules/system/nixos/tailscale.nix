{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.tailscale.enable = true;
}
