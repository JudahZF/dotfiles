{ inputs, ... }: {
  systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

  _module.args = let
    unfreeConfig = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [ "python3.13-ecdsa-0.19.2" ];
    };

    lndirOverlay = final: prev: { lndir = prev.xorg.lndir; };

    # Upstream nixpkgs pi-coding-agent 0.78.0 assumes koffi's native build
    # directory exists during Darwin postInstall cleanup. npmInstallHook prunes
    # it first on aarch64-darwin, causing rebuilds to fail with:
    #   find: .../node_modules/koffi/build/koffi: No such file or directory
    piCodingAgentOverlay = final: prev: {
      pi-coding-agent = prev.pi-coding-agent.overrideAttrs (old: {
        postInstall = final.lib.replaceStrings [''
          find "$nm/koffi/build/koffi" -mindepth 1 -maxdepth 1 -type d \
            ! -name 'darwin_*' -exec rm -r {} +
        ''] [''
          if [ -d "$nm/koffi/build/koffi" ]; then
            find "$nm/koffi/build/koffi" -mindepth 1 -maxdepth 1 -type d \
              ! -name 'darwin_*' -exec rm -r {} +
          fi
        ''] old.postInstall;
      });
    };
  in {
    inherit lndirOverlay unfreeConfig;
    flakeOverlays =
      [ inputs.nix-xilinx.overlay inputs.firefox-addons.overlays.default ];

    mkPkgs = { system, darwin ? false, overlays ? [ ], extraConfig ? { }, }:
      import (if darwin then inputs.nixpkgs-darwin else inputs.nixpkgs) {
        inherit system overlays;
        config = unfreeConfig // extraConfig;
      };

    mkUnstablePkgs = system:
      import inputs.nixpkgs-unstable {
        inherit system;
        config = unfreeConfig;
        overlays = [ piCodingAgentOverlay ];
      };
  };
}
