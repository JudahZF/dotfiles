{
    description = "JF Linux Flake";

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

    outputs = { self, nix-darwin, nix-homebrew, home-manager, ... }:
    {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#simple
        darwinConfigurations.gale = nix-darwin.lib.darwinSystem {
            modules = [
                home-manager.darwinModules.home-manager {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.judahfuller = { ... }: {
                        imports = [(import ./modules/home/macos.nix {
                            configDir = "/Users/judahfuller/dotfiles";
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
