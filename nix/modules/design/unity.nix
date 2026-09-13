{
  pkgs,
  lib,
  options,
  ...
}:
lib.mkMerge [
  # Unity Hub manages editor versions and provides their FHS environment on NixOS.
  (lib.mkIf pkgs.stdenv.isLinux { environment.systemPackages = [ pkgs.unityhub ]; })
  (lib.optionalAttrs (options ? homebrew) { homebrew.casks = [ "unity-hub" ]; })
]
