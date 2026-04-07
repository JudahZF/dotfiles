{ inputs, mkPkgs, mkUnstablePkgs, lndirOverlay, ... }: {
  flake.images.jfpi = (inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = {
      inherit inputs;
      system = "aarch64-linux";
      username = "judahf";
      dotfiles = inputs.dotfiles;
      pkgs = mkPkgs {
        system = "aarch64-linux";
        overlays = [ lndirOverlay ];
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
}
