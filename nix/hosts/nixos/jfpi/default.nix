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

  # Disable greetd (conflicts with GDM, which is enabled in gnome.nix)
  services.greetd.enable = lib.mkForce false;

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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  system.stateVersion = "25.05";
}
