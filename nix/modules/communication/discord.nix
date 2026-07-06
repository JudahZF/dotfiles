{
  pkgs,
  lib,
  options,
  ...
}:

lib.mkMerge [
  (lib.optionalAttrs (options ? homebrew) {
    homebrew.casks = [ "discord" ];
  })

  # Discord not available on aarch64-linux
  (lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.hostPlatform.isx86_64) {
    environment.systemPackages = [ pkgs.discord ];
  })
]
