{
  description = "Judah\'s music config";

  inputs = {
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
    environment.systemPackages =
    [
        pkgs.ansible
        pkgs.bun
        pkgs.cmake
        pkgs.gitkraken
        pkgs.node
        pkgs.postman
        pkgs.python3
        pkgs.rpi-imager
        pkgs.zed
    ];

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    };
  in
  {
  };
}
