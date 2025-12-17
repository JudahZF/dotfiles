{
  description = "JF Flake";

  inputs = {
    cider = {
      url = "github:Fuwn/cider.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "path:..";
      flake = false;
    };

    elephant.url = "github:abenz1267/elephant";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nvf = {
      url = "github:JudahZF/nvf/telescope_gitFiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;

      stateVersion = "24.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };

    in {
      darwinConfigurations = {
        gale = libx.mkDarwin { hostname = "gale"; };
      };

      nixosConfigurations = {
        popper = libx.mkNixos { hostname = "popper"; };
        zevlor = libx.mkNixos { hostname = "zevlor"; };
        gitlab = libx.mkNixos { hostname = "gitlab"; };
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
            };
          };
          specialArgs = {
            inherit inputs;
            dotfiles = inputs.dotfiles;
            pkgs-unstable = import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
          };
        };

        gitlab = {
          deployment = {
            targetHost = "192.168.10.119";
            targetUser = "root";
            buildOnTarget = false;
          };
          imports = [
            ./hosts/nixos/gitlab
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
