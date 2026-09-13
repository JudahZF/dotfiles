{
  pkgs,
  lib,
  options,
  ...
}:
lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux { environment.systemPackages = [ pkgs.blender ]; })
  (lib.optionalAttrs (options ? homebrew) { homebrew.casks = [ "blender" ]; })
]
