{
    description = "Macbook Air flake";

    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin = {
            url = "github:LnL7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, home-manager, ... }:
    {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
            modules = [
                ./modules/macos/system.nix
                ./modules/nix/system.nix
                nix-homebrew.darwinModules.nix-homebrew
                {
                    nix-homebrew = {
                        enable = true;
                        enableRosetta = true;
                        user = "Judah Fuller";
                        autoMigrate = true;
                    };
                }
                ./modules/nix/standard.nix
                ./modules/nix/dev.nix
                ./modules/macos/design.nix
                ./modules/macos/production.nix
                ./modules/macos/music.nix
                ./modules/home/home.nix
            ];
        };
        # Expose the package set, including overlays, for convenience.
        darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
