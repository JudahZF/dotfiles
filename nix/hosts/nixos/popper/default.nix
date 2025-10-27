{
  config,
  lib,
  pkgs,
  inputs,
  dotfiles,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    ./../../common
    (import ./../../common/dev-packages.nix { inherit inputs pkgs; })
    ./../../common/dev-packages-config.nix
    ./../../nix/login.nix
  ];

  # BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # KERNEL
  boot.kernelModules = [ "drivetemp" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernelParams = [
    "i915.fastboot=1"
    "i915.enable_guc=3"
  ];

  # HARDWARE
  ## Thunderbolt
  services.hardware.bolt.enable = true;
  ## quicksync
  hardware.firmware = [ pkgs.linux-firmware ];
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

  # NETWORK
  networking = {
    firewall.enable = false;
    hostName = "popper";
    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.33";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = "192.168.1.1";
    nameservers = [
      "192.168.1.2"
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # LOCALISATION
  console.keyMap = "uk";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  time.timeZone = "Europe/London";

  # USER
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit dotfiles; };
    users.judahf = {
      imports = [ ./../../../home/judahfuller.nix ];
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
    ];
    packages = with pkgs; [
      home-manager
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # PACKAGES
  environment.systemPackages = with pkgs; [
    btrfs-progs
    git
    wget
    zsh
  ];
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;

  # SERVICES
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
  system.stateVersion = "25.05";
}
