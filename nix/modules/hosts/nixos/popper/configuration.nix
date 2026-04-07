{ pkgs, inputs, dotfiles, self, ... }: {
  imports = [
    ./hardware.nix
    self.nixosModules.browsers
    self.nixosModules.cli
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
    inputs.home-manager.nixosModules.home-manager
  ];

  # GPU (Intel QuickSync)
  boot.kernelParams = [ "i915.fastboot=1" "i915.enable_guc=3" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
      intel-compute-runtime
      intel-gmmlib
      vpl-gpu-rt
      libva
      libva-utils
      glxinfo
      pciutils
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
    LIBVA_MESSAGING_LEVEL = "1";
    GST_VAAPI_ALL_DRIVERS = "1";
  };

  # HARDWARE
  services.hardware.bolt.enable = true;

  # NETWORK
  networking = {
    hostName = "popper";
    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.1.33";
          prefixLength = 24;
        }];
      };
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.2" "1.1.1.1" "8.8.8.8" ];
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
  };

  users.users.judahf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "render" "video" ];
    packages = with pkgs; [ home-manager ];
  };

  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "25.05";
}
