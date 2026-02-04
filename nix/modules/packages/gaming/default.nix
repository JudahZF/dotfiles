{ pkgs, lib, ... }:
# Gaming packages - NixOS only, x86_64 only (Steam requires 32-bit support)
lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64) {
  programs.steam.enable = true;
}
