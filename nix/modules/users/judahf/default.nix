{ self, ... }: {
  imports = [
    self.homeModules.home
    self.homeModules.cli
    self.homeModules.browsers
    self.homeModules.media
    self.homeModules.security
    ./identity.nix
    ./darwin-home.nix
    ./linux-home.nix
  ];
}
