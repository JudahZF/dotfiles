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
    # With NIXOS_OZONE_WL set, nixpkgs' wrapper also adds
    # --enable-features=WaylandWindowDecorations and --enable-wayland-ime,
    # which make Discord start broken on niri. Drop that branch and request
    # native Wayland directly. Discord is frameless, so keep decorations off.
    environment.systemPackages = [
      (
        (pkgs.discord.override {
          commandLineArgs = "--ozone-platform=wayland --disable-features=WaylandWindowDecorations";
        }).overrideAttrs
          (prev: {
            postInstall = (prev.postInstall or "") + ''
              wrapProgramShell $out/opt/Discord/Discord --unset NIXOS_OZONE_WL
            '';
          })
      )
    ];
  })
]
