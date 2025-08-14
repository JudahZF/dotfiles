{
  description = "JF Flake";

  inputs = {
    dotfiles = {
      url = "path:..";
      flake = false;
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;

      stateVersion = "24.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };

    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations.gale = nix-darwin.lib.darwinSystem {
            pkgs = import nixpkgs {
                config.allowUnfree = true;
            };
        modules = [
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.judahfuller = { ... }: {
              imports = [(import ./modules/home/macos.nix {
                configDir = dotfiles;
              })];
            };
          }
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "Judah Fuller";
              mutableTaps = true;
            };
          }
          ./modules/nix/dev.nix
          ./modules/nix/neovim.nix
          ./modules/nix/standard.nix
          ./modules/nix/system.nix
          ./modules/macos/design.nix
          ./modules/macos/gaming.nix
          ./modules/macos/music.nix
          ./modules/macos/production.nix
          ./modules/macos/system.nix
          ./modules/macos/work.nix
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.gale.pkgs;
    };
}
