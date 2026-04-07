{ inputs, mkUnstablePkgs, unfreeConfig, ... }: {
  flake.colmena = {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config = unfreeConfig;
      };
      specialArgs = {
        inherit inputs;
        system = "x86_64-linux";
        username = "judahf";
        dotfiles = inputs.dotfiles;
        pkgs-unstable = mkUnstablePkgs "x86_64-linux";
      };
    };

    gitlab = { ... }: {
      deployment = {
        targetHost = "192.168.10.30";
        targetUser = "judahf";
        buildOnTarget = true;
      };

      imports = [
        ../hosts/nixos/gitlab/configuration.nix
        inputs.nix-index-database.nixosModules.nix-index
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
      ];
    };

    clawdbot = { ... }: {
      deployment = {
        targetHost = "192.168.10.31";
        targetUser = "judahf";
        buildOnTarget = true;
      };

      imports = [
        ../hosts/nixos/clawdbot/configuration.nix
        inputs.nix-index-database.nixosModules.nix-index
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
      ];
    };
  };
}
