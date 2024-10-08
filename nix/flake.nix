{
    description = "Macbook Air flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "github:LnL7/nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    };

    outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, ... }:
        {
            # Build darwin flake using:
            # $ darwin-rebuild build --flake .#simple
            darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
                modules = [
                    nix-homebrew.darwinModules.nix-homebrew
                    {
                        nix-homebrew = {
                            enable = true;
                            enableRosetta = true;
                            user = "Judah Fuller";
                        };
                    }
                    ./modules/nix/system.nix
                    ./modules/nix/standard.nix
                    ./modules/nix/dev.nix
                    ./modules/macos/design.nix
                    ./modules/macos/production.nix
                    ./modules/macos/music.nix
                    ./modules/macos/system.nix
                ];
            };
            # Expose the package set, including overlays, for convenience.
            darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
