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
    # The NIXOS_OZONE_WL wrapper enables WaylandWindowDecorations. Discord is
    # frameless, so on niri it then draws smaller than its window. Chromium
    # applies --disable-features over --enable-features.
    environment.systemPackages = [
      (pkgs.discord.override {
        commandLineArgs = "--disable-features=WaylandWindowDecorations";
      })
    ];
  })
]
