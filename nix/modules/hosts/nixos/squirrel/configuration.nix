{
  pkgs,
  inputs,
  dotfiles,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    self.nixosModules.browsers
    self.nixosModules.communication
    self.nixosModules.desktop
    self.nixosModules.dev
    self.nixosModules.fonts
    self.nixosModules.home-manager-system
    self.nixosModules.libraries
    self.nixosModules.networking
    self.nixosModules.nix-config
    self.nixosModules.nixos
    self.nixosModules.productivity
    self.nixosModules.security
    self.nixosModules.shell
    self.nixosModules.utilities
    inputs.home-manager.nixosModules.home-manager
  ];

  services.dotfilesAutoUpdate.enable = true;

  networking.hostName = "squirrel";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotfiles self;
    };
    users.judahf = {
      imports = [
        inputs.zen-browser.homeModules.beta
        self.homeModules.user-judahf
        self.homeModules.desktop
      ];
    };
    users.bigchurch = {
      imports = [
        self.homeModules.user-bigchurch
      ];
    };
  };

  users = {
    users.judahf = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "networkmanager"
        "render"
        "video"
        "input"
      ];
      packages = with pkgs; [ home-manager ];
    };

    users.bigchurch = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "video"
        "input"
      ];
      packages = with pkgs; [ home-manager ];
    };

    defaultUserShell = pkgs.zsh;
  };

  # Reflects original install (newer than popper/zevlor); do not normalize.
  system.stateVersion = "26.05";
}
