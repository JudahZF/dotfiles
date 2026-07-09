{ self, ... }: {
  imports = [
    self.homeModules.home
    self.homeModules.browsers
    self.homeModules.media
    self.homeModules.security
    self.homeModules.utilities
    ./agents.nix
    ./identity.nix
    ./darwin-home.nix
    ./shell-home.nix
    ./pi.nix
  ];
}
