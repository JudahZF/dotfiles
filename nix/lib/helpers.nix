{ inputs, outputs, stateVersion, flake-overlays, ... }: {
  mkDarwin = { hostname, username ? "judahfuller", system ? "aarch64-darwin", }:
    let
      customConfPath = ./../hosts/darwin/${hostname};
      customConf = if builtins.pathExists customConfPath then
        (customConfPath + "/default.nix")
      else
        ./../hosts/darwin/default-dock.nix;
    in inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit system inputs username;
        dotfiles = inputs.dotfiles;
        pkgs = import inputs.nixpkgs-darwin {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      };
      modules = [
        ../modules
        customConf
        inputs.home-manager.darwinModules.home-manager
        {
          networking.hostName = hostname;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            dotfiles = inputs.dotfiles;
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config = {
                allowUnfree = true;
                allowUnfreePredicate = _: true;
              };
            };
          };
          home-manager.users.${username} = {
            imports = [ ./../home/users/judahf ];
          };
        }
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            autoMigrate = true;
            mutableTaps = true;
            user = "${username}";
            taps = with inputs; {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
          };
        }
        inputs.sops-nix.darwinModules.sops
      ];
    };

  mkNixos = { hostname, username ? "judahf", system ? "x86_64-linux", }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs username system;
        name = hostname;
        dotfiles = inputs.dotfiles;
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [] ++ flake-overlays;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      };
      modules = [
        ../hosts/nixos/${hostname}
        inputs.nix-index-database.nixosModules.nix-index
        inputs.sops-nix.nixosModules.sops
      ];
    };
}
