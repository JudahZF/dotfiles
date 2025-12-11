{ pkgs, inputs, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../common/all
    ./../../common/nixOS
    ./../../common/all/apps/discord.nix
    ./../../common/all/apps/steam.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # NETWORK
  networking = {
    hostName = "zevlor";
    interfaces = {
      enp9s0 = {
        useDHCP = true;
      };
    };
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

  system.stateVersion = "25.05";
}
