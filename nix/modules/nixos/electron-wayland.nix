{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
