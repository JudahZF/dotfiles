{ inputs, outputs, stateVersion, flake-overlays, ... }:
let helpers = import ./helpers.nix { inherit inputs outputs stateVersion flake-overlays; };
in {
  inherit (helpers)
    mkDarwin
    mkNixos
  ;
}
