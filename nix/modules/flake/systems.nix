{ inputs, ... }: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  _module.args = let
    unfreeConfig = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
    };

    lndirOverlay = final: prev: { lndir = prev.xorg.lndir; };
  in {
    inherit lndirOverlay unfreeConfig;
    flakeOverlays = [
      inputs.nix-xilinx.overlay
      inputs.firefox-addons.overlays.default
    ];

    mkPkgs = {
      system,
      darwin ? false,
      overlays ? [ ],
      extraConfig ? { },
    }:
      import (if darwin then inputs.nixpkgs-darwin else inputs.nixpkgs) {
        inherit system overlays;
        config = unfreeConfig // extraConfig;
      };

    mkUnstablePkgs = system:
      import inputs.nixpkgs-unstable {
        inherit system;
        config = unfreeConfig;
      };
  };
}
