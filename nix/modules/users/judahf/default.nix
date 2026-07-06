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
    ./linux-home.nix
    ./pi.nix
  ];
}
