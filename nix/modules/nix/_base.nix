{
  description = "Judah\'s nix config";

  inputs = {
    # agenix.url = "github:ryantm/agenix";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages =
        [
          pkgs.mkalias
        ];

      services.nix-daemon.enable = true;

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 4;
    };
  in
  {
    packages.x86_64-linux.default = configuration;
    packages.aarch64-darwin.default = configuration;
  };
}
