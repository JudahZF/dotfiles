{ inputs, lib, lndirOverlay, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      mkNiriConfig = import ../desktop/niri/settings.nix { inherit lib; };
      wrappedPkgs = pkgs.extend lndirOverlay;
    in
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux (
        let
          noctalia-shell-wrapped = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
            pkgs = wrappedPkgs;
            package = inputs.nixpkgs-unstable.legacyPackages.${system}.noctalia-shell;
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
