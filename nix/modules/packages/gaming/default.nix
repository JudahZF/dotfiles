{ pkgs, lib, ... }:
# Gaming packages - NixOS only
lib.mkIf pkgs.stdenv.isLinux {
  programs.steam.enable = true;
}
