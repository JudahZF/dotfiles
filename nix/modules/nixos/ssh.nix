{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.openssh.enable = true;
}
