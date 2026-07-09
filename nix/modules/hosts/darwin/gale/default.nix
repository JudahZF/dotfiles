{
  inputs,
  self,
  mkPkgs,
  mkUnstablePkgs,
  flakeOverlays,
  ...
}:
let
  system = "aarch64-darwin";
  username = "judahfuller";
  pkgs-unstable = mkUnstablePkgs system;
  pkgs = mkPkgs {
    inherit system;
    darwin = true;
    overlays = flakeOverlays;
    extraConfig = {
      permittedInsecurePackages = [ "python3.13-ecdsa-0.19.2" ];
    };
  };
in
{
  flake.darwinConfigurations.gale = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit
        inputs
        self
        system
        username
        ;
      inherit (inputs) dotfiles;
      inherit pkgs-unstable;
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
      self.darwinModules.shell
      self.darwinModules.utilities
      { nixpkgs.pkgs = pkgs; }
      { environment.systemPackages = [ inputs.maclocker.packages.${system}.maclocker ]; }
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.nix-xcodes.darwinModules.default
      {
        networking.hostName = "gale";
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs self;
            inherit (inputs) dotfiles;
            inherit pkgs-unstable;
          };
          users.${username}.imports = [
            inputs.zen-browser.homeModules.beta
            self.homeModules.user-judahf
          ];
        };
      }
      {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          autoMigrate = true;
          user = username;
        };
      }
    ];
  };
}
