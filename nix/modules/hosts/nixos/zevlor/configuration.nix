{ pkgs, inputs, dotfiles, self, ... }: {
  imports = [
    ./hardware.nix
    self.nixosModules.browsers
    self.nixosModules.communication
    self.nixosModules.desktop
    self.nixosModules.dev
    self.nixosModules.fonts
    self.nixosModules.home-manager-system
    self.nixosModules.libraries
    self.nixosModules.nix-config
    self.nixosModules.nixos
    self.nixosModules.security
    self.nixosModules.secrets
    self.nixosModules.shell
    self.nixosModules.utilities
    ../../../modules/nixos/thrustmaster.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # GPU
  boot.initrd.kernelModules = [ "amdgpu" ];
  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
  hardware.graphics.extraPackages = with pkgs; [ amdvlk rocmPackages.clr.icd ];
  hardware.graphics.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  environment.systemPackages = with pkgs; [ clinfo openrgb ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # NETWORK
  networking = {
    hostName = "zevlor";
    interfaces = { enp9s0 = { useDHCP = true; }; };
  };

  # USER
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dotfiles self; };
    users.judahf = {
      imports = [
        inputs.walker.homeManagerModules.default
        inputs.zen-browser.homeModules.beta
        self.homeModules.user-judahf
        self.homeModules.desktop
        ./hyprland.nix
      ];
    };
    users.richf = { imports = [ self.homeModules.user-richf ]; };
    users.beckf = { imports = [ self.homeModules.user-beckf ]; };
  };

  users.users.judahf = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "networkmanager" "render" "video" "input" "plugdev" ];
    packages = with pkgs; [ home-manager ];
  };

  users.users.richf = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "input" ];
    packages = with pkgs; [ home-manager ];
  };

  users.users.beckf = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "input" ];
    packages = with pkgs; [ home-manager ];
  };

  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "25.05";
}
