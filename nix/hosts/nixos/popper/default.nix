{ pkgs, inputs, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../common/all
    ./../../common/nixOS
    ./../../common/all/apps/steam.nix
    ./../../common/all/dev-packages.nix
    ./../../common/all/uni-packages.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # GPU (Intel QuickSync)
  boot.kernelParams = [ "i915.fastboot=1" "i915.enable_guc=3" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # VA-API drivers
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver
      libvdpau-va-gl

      # OpenCL and compute support
      intel-compute-runtime
      intel-gmmlib
      vpl-gpu-rt

      # VA-API utilities and libraries
      libva
      libva-utils

      # Diagnostic tools
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
  ## Thunderbolt
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
    extraSpecialArgs = { inherit inputs dotfiles; };
    users.judahf = {
      imports = [
        inputs.walker.homeManagerModules.default
        inputs.zen-browser.homeModules.beta
        ./../../../home/judahf.nix
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  system.stateVersion = "25.05";
}
