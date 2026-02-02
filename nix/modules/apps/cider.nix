{ pkgs, lib, ... }: {
  # NixOS-specific Cider configuration
  # programs.cider.enable = lib.mkIf pkgs.stdenv.isLinux true;

  # Note: Cider for home-manager is handled in home/apps/cider.nix
  # This module is for system-level Cider configuration if needed
}
