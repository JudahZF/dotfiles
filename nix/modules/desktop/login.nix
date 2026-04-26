{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.displayManager.ly.enable = true;
}
