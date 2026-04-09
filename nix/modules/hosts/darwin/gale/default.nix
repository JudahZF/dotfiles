{ inputs, self, mkPkgs, mkUnstablePkgs, lndirOverlay, ... }:
let
  system = "aarch64-darwin";
  username = "judahfuller";
  pkgs = mkPkgs {
    inherit system;
    darwin = true;
    overlays = [ lndirOverlay ];
    extraConfig = {
      permittedInsecurePackages = [ "python3.12-ecdsa-0.19.1" ];
    };
  };
in {
  flake.darwinConfigurations.gale = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs self system username;
      dotfiles = inputs.dotfiles;
      pkgs-unstable = mkUnstablePkgs system;
    };
    modules = [
      ./configuration.nix
      self.darwinModules.browsers
      self.darwinModules.communication
      self.darwinModules.darwin
      self.darwinModules.design
      self.darwinModules.desktop
      self.darwinModules.dev
      self.darwinModules.fonts
      self.darwinModules.gaming
      self.darwinModules.home-manager-system
      self.darwinModules.libraries
      self.darwinModules.media
      self.darwinModules.networking
      self.darwinModules.nix-config
      self.darwinModules.productivity
      self.darwinModules.security
      self.darwinModules.secrets
      self.darwinModules.shell
      self.darwinModules.utilities
      { nixpkgs.pkgs = pkgs; }
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-zerobrew.darwinModules.nix-zerobrew
      inputs.sops-nix.darwinModules.sops
      {
        networking.hostName = "gale";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs self;
          dotfiles = inputs.dotfiles;
          pkgs-unstable = mkUnstablePkgs system;
        };
        home-manager.users.${username}.imports = [
          inputs.zen-browser.homeModules.beta
          self.homeModules.user-judahf
        ];
      }
      {
        nix-zerobrew = {
          enable = true;
          enableRosetta = true;
          autoMigrate = true;
          user = username;
          package = inputs.nix-zerobrew.packages.${system}.zerobrew;
          packageRosetta = inputs.nix-zerobrew.packages.x86_64-darwin.zerobrew;
          prefixes = {
            "/opt/zerobrew".linkDir = "/opt/homebrew";
            "/usr/local/zerobrew".linkDir = "/usr/local";
          };
        };
      }
    ];
  };
}
