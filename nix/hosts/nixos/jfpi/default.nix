{ pkgs, lib, inputs, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    # Minimal modules - no desktop/GNOME
    ./../../../modules/system
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader - RPi5 uses extlinux via nixos-hardware
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Network - NetworkManager for easy WiFi management
  networking = {
    hostName = "jfpi";
    networkmanager.enable = true;
    wireless.enable = false; # Managed by NetworkManager
  };

  # SSH for headless access
  services.openssh.enable = true;

  # User
  users.users.judahf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO"
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Minimal home-manager - just shell basics
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dotfiles; };
    users.judahf = {
      home.stateVersion = "24.05";
      home.username = "judahf";
      home.homeDirectory = "/home/judahf";
      programs.zsh.enable = true;
      programs.git.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
