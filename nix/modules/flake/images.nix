{
  inputs,
  mkPkgs,
  mkUnstablePkgs,
  lib,
  ...
}:
{
  flake.images = lib.optionalAttrs (builtins.pathExists ../hosts/nixos/jfpi/configuration.nix) {
    jfpi =
      (inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          system = "aarch64-linux";
          username = "judahf";
          inherit (inputs) dotfiles;
          pkgs = mkPkgs {
            system = "aarch64-linux";
          };
          pkgs-unstable = mkUnstablePkgs "aarch64-linux";
        };
        modules = [
          (inputs.nixpkgs + "/nixos/modules/installer/sd-card/sd-image-aarch64.nix")
          ../hosts/nixos/jfpi/configuration.nix
          inputs.nixos-hardware.nixosModules.raspberry-pi-5
          inputs.nix-index-database.nixosModules.nix-index
          inputs.sops-nix.nixosModules.sops
          { sdImage.compressImage = true; }
        ];
      }).config.system.build.sdImage;
  };
}
