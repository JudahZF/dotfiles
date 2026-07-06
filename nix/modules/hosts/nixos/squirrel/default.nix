{
  inputs,
  self,
  mkPkgs,
  mkUnstablePkgs,
  flakeOverlays,
  ...
}:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.squirrel = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = mkPkgs {
      inherit system;
      overlays = flakeOverlays;
    };
    specialArgs = {
      inherit inputs self system;
      inherit (inputs) dotfiles;
      name = "squirrel";
      username = "judahf";
      pkgs-unstable = mkUnstablePkgs system;
    };
    modules = [
      ./configuration.nix
      inputs.nix-index-database.nixosModules.nix-index
      inputs.sops-nix.nixosModules.sops
    ];
  };
}
