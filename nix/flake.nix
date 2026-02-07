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

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-xilinx = {
        inputs.nixpkgs.follows = "nixpkgs";
        url = "github:MIT-OpenCompute/xilinx-flake";
      };

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

      flake-overlays = [
        nix-xilinx.overlay
      ];

      libx = import ./lib { inherit inputs outputs stateVersion flake-overlays; };
    in {
      darwinConfigurations = {
        gale = libx.mkDarwin { hostname = "gale"; };
      };

      nixosConfigurations = {
        popper = libx.mkNixos { hostname = "popper"; };
        zevlor = libx.mkNixos { hostname = "zevlor"; };
        gitlab = libx.mkNixos { hostname = "gitlab"; };
        clawdbot = libx.mkNixos { hostname = "clawdbot"; };
        jfpi = libx.mkNixos { hostname = "jfpi"; system = "aarch64-linux"; };
      };

      # SD card image for Raspberry Pi 5
      images.jfpi = (nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          system = "aarch64-linux";
          username = "judahf";
          dotfiles = inputs.dotfiles;
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config = { allowUnfree = true; };
            overlays = [ (final: prev: { lndir = prev.xorg.lndir; }) ];
          };
          pkgs-unstable = import inputs.nixpkgs-unstable {
            system = "aarch64-linux";
            config = { allowUnfree = true; };
          };
        };
        modules = [
          (nixpkgs + "/nixos/modules/installer/sd-card/sd-image-aarch64.nix")
          ./hosts/nixos/jfpi
          inputs.nixos-hardware.nixosModules.raspberry-pi-5
          inputs.nix-index-database.nixosModules.nix-index
          inputs.sops-nix.nixosModules.sops
          { sdImage.compressImage = true; }
        ];
      }).config.system.build.sdImage;

      # Evaluation checks - run with `nix flake check`
      checks = {
        x86_64-linux = {
          popper = self.nixosConfigurations.popper.config.system.build.toplevel;
          zevlor = self.nixosConfigurations.zevlor.config.system.build.toplevel;
          gitlab = self.nixosConfigurations.gitlab.config.system.build.toplevel;
          clawdbot = self.nixosConfigurations.clawdbot.config.system.build.toplevel;
        };
        aarch64-darwin = {
          gale = self.darwinConfigurations.gale.config.system.build.toplevel;
        };
        aarch64-linux = {
          jfpi = self.nixosConfigurations.jfpi.config.system.build.toplevel;
        };
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
            system = "x86_64-linux";
            username = "judahf";
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

        gitlab = { name, nodes, pkgs, ... }: {
          deployment = {
            targetHost = "192.168.10.30";
            targetUser = "judahf";
            # Build on the target machine since we're on aarch64-darwin
            buildOnTarget = true;
          };

          imports = [
            ./hosts/nixos/gitlab
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
          ];
        };

        clawdbot = { name, nodes, pkgs, ... }: {
          deployment = {
            targetHost = "192.168.10.31";  # Update this IP
            targetUser = "judahf";
            buildOnTarget = true;
          };

          imports = [
            ./hosts/nixos/clawdbot
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
