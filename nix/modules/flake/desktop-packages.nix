{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
    let
      mkNiriConfig = import ../desktop/niri/settings.nix { inherit lib; };
      wrappedPkgs = pkgs;
    in
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux (
        let
          unstable = inputs.nixpkgs-unstable.legacyPackages.${system};

          # breakpad 2024.02.16 fails to link microdump_stackwalk on the current
          # unstable toolchain (missing FastSourceLineResolver::Module vtable).
          # Drop this once NixOS/nixpkgs#569323 reaches nixos-unstable.
          noctalia-shell = unstable.noctalia-shell.override {
            noctalia-qs = unstable.noctalia-qs.override {
              breakpad = unstable.breakpad.overrideAttrs (prev: {
                patches = (prev.patches or [ ]) ++ [
                  ../desktop/noctalia/breakpad-fix-vtable-link.patch
                ];
              });
            };
          };

          noctalia-shell-wrapped = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
            pkgs = wrappedPkgs;
            package = noctalia-shell;
            outOfStoreConfig = "$HOME/.config/noctalia";
            autoCopyConfig = false;
            enableDumpScript = true;
          };

          mkNiriPackage =
            host: outputs:
            inputs.wrapper-modules.wrappers.niri.wrap {
              pkgs = wrappedPkgs;
              package = wrappedPkgs.niri;
              "config.kdl".content = mkNiriConfig {
                inherit host outputs;
                noctaliaPackage = noctalia-shell-wrapped;
                xwaylandSatellitePackage = wrappedPkgs.xwayland-satellite;
              };
            };
        in
        {
          inherit noctalia-shell-wrapped;
          niri-popper = mkNiriPackage "popper" [
            {
              name = "HDMI-A-3";
              mode = "1920x1080@60";
              x = 0;
              y = 0;
            }
            {
              name = "HDMI-A-2";
              mode = "1920x1080@60";
              x = 1920;
              y = 0;
            }
          ];
          niri-zevlor = mkNiriPackage "zevlor" [
            {
              name = "HDMI-A-3";
              mode = "1920x1080@60";
              x = 0;
              y = 0;
            }
            {
              name = "HDMI-A-2";
              mode = "1920x1080@60";
              x = 1920;
              y = 0;
            }
          ];
        }
      );
    };
}
