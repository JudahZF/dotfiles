{ pkgs, lib, inputs, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../../modules
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


  # GPU - VideoCore VII
  hardware.graphics.enable = true;

  # User
  users.users.judahf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
    packages = with pkgs; [ home-manager ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dotfiles; };
    users.judahf = {
      imports = [ ./../../../home/users/judahf ];
    };
  };

  system.stateVersion = "25.05";
}
