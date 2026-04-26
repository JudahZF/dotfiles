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
    ./niri.nix
    ./steam.nix
    ../../../gaming/steam.nix
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
    self.nixosModules.secrets
    self.nixosModules.shell
    self.nixosModules.utilities
    ../../../nixos/thrustmaster.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd
  ];
  hardware.graphics.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  environment.systemPackages = with pkgs; [
    clinfo
    openrgb
  ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # NETWORK
  networking = {
    hostName = "zevlor";
    networkmanager.ensureProfiles.profiles.enp9s0 = {
      connection = {
        id = "enp9s0";
        type = "ethernet";
        interface-name = "enp9s0";
        autoconnect = true;
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };

  # USER
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dotfiles self; };
    users.judahf = {
      imports = [
        inputs.zen-browser.homeModules.beta
        self.homeModules.user-judahf
        self.homeModules.desktop
        self.homeModules.hyprland
        ./hyprland.nix
      ];
    };
    users.richf = {
      imports = [ self.homeModules.user-richf ];
    };
    users.beckf = {
      imports = [ self.homeModules.user-beckf ];
    };
  };

  users.users.judahf = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "render"
      "video"
      "input"
      "plugdev"
    ];
    packages = with pkgs; [ home-manager ];
  };

  users.users.richf = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "video"
      "input"
    ];
    packages = with pkgs; [ home-manager ];
  };

  users.users.beckf = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "video"
      "input"
    ];
    packages = with pkgs; [ home-manager ];
  };

  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "25.05";
}
