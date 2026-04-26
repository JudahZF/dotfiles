{
  inputs,
  self,
  mkPkgs,
  mkUnstablePkgs,
  lndirOverlay,
  flakeOverlays,
  ...
}:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.zevlor = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = mkPkgs {
      inherit system;
      overlays = [ lndirOverlay ] ++ flakeOverlays;
    };
    specialArgs = {
      inherit inputs self system;
      name = "zevlor";
      username = "judahf";
      dotfiles = inputs.dotfiles;
      pkgs-unstable = mkUnstablePkgs system;
    };
    modules = [
      ./configuration.nix
      inputs.nix-index-database.nixosModules.nix-index
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
