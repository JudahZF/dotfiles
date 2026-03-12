{ inputs, outputs, stateVersion, flake-overlays, ... }: {
  mkDarwin = { hostname, username ? "judahfuller", system ? "aarch64-darwin", }:
    let
      customConfPath = ./../hosts/darwin/${hostname};
      customConf = if builtins.pathExists customConfPath then
        (customConfPath + "/default.nix")
      else
        ./../hosts/darwin/default-dock.nix;
      pkgs = import inputs.nixpkgs-darwin {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
        };
        overlays = [
          (final: prev: { lndir = prev.xorg.lndir; })
          inputs.opencode-nix.overlays.default
        ];
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
      };
    in inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit system inputs username;
        dotfiles = inputs.dotfiles;
        inherit pkgs-unstable;
      };
      modules = [
        ../modules
        customConf
        { nixpkgs.pkgs = pkgs; }
        inputs.home-manager.darwinModules.home-manager
        {
          networking.hostName = hostname;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            dotfiles = inputs.dotfiles;
            inherit pkgs-unstable;
          };
          home-manager.users.${username} = {
            imports = [ ./../home/users/judahf ];
          };
        }
        inputs.nix-zerobrew.darwinModules.nix-zerobrew
        {
          nix-zerobrew = {
            enable = true;
            enableRosetta = true;
            autoMigrate = true;
            user = "${username}";
            package = inputs.nix-zerobrew.packages.${system}.zerobrew;
            packageRosetta = inputs.nix-zerobrew.packages.x86_64-darwin.zerobrew;
            prefixes = {
              "/opt/zerobrew".linkDir = "/opt/homebrew";
              "/usr/local/zerobrew".linkDir = "/usr/local";
            };
          };
        }
        inputs.sops-nix.darwinModules.sops
      ];
    };

  mkNixos = { hostname, username ? "judahf", system ? "x86_64-linux", extraOverlays ? [], }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
        };
        overlays = [
          (final: prev: { lndir = prev.xorg.lndir; })
          inputs.opencode-nix.overlays.default
        ] ++ flake-overlays ++ extraOverlays;
      };
    in inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit inputs username system;
        name = hostname;
        dotfiles = inputs.dotfiles;
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
