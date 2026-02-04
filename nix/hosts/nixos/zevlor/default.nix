{ pkgs, inputs, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../../modules
    ./../../../modules/hardware/thrustmaster.nix
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
    extraSpecialArgs = { inherit inputs dotfiles; };
    users.judahf = {
      imports = [
        inputs.walker.homeManagerModules.default
        inputs.zen-browser.homeModules.beta
        ./../../../home/users/judahf
        ./../../../home/apps/cider.nix
        ./../../../home/desktop
        ./hyprland.nix
      ];
    };
    users.richf = { imports = [ ./../../../home/users/richf ]; };
  };

  users.users.judahf = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "networkmanager" "render" "video" "input" ];
    packages = with pkgs; [ home-manager ];
  };

  users.users.richf = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "video" "input" ];
    packages = with pkgs; [ home-manager ];
  };

  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "25.05";
}
