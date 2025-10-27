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

    nvf = {
      url = "github:JudahZF/nvf/telescope_gitFiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omnixy = {
      url = "github:JudahZF/omnixy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;

      stateVersion = "24.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };

    in
    {
      darwinConfigurations = {
        gale = libx.mkDarwin {
          hostname = "gale";
        };
      };
      nixosConfigurations.popper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          name = "popper";
          system = "x86_64-linux";
          username = "judahf";
          dotfiles = inputs.dotfiles;
        };
        modules = [ ./hosts/nixos/popper ];
      };
    };
}
