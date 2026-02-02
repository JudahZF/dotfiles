{ pkgs, lib, inputs, config, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../../modules/system/nixos/ssh.nix
    ./../../../modules/system/nixos/tailscale.nix
    ./../../../modules/system/nixos/network.nix
    ./../../../modules/apps/clawdbot.nix
    ./../../../modules/system/nix.nix
    ./../../../modules/system/nixpkgs.nix
    ./../../../modules/system/sops.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # BOOTLOADER - Use GRUB for BIOS boot (Proxmox VM)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # SOPS SECRETS CONFIGURATION
  sops = {
    defaultSopsFile = lib.mkForce "${dotfiles}/secrets/clawdbot.yaml";
    secrets = {
      "anthropic_api_key" = {
        owner = "clawdbot";
        group = "clawdbot";
        mode = "0640";
      };
    };

    templates."clawdbot-env" = {
      content = ''
        ANTHROPIC_API_KEY=${config.sops.placeholder."anthropic_api_key"}
      '';
      owner = "clawdbot";
      group = "clawdbot";
      mode = "0640";
    };
  };

  # NETWORK
  networking = {
    hostName = "clawdbot";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.31";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" "1.1.1.1" "8.8.8.8" ];
  };

  # LOCALISATION
  console.keyMap = "uk";
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  # USER
  users.users.judahf = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO"
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # HOME-MANAGER for judahf user
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs dotfiles; };
    users.judahf = {
      imports = [
        ./../../../home/users/judahf
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # PACKAGES
  environment.systemPackages = with pkgs; [
    git
    wget
    zsh
    htop
    vim
    tmux
  ];

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.qemuGuest.enable = true;

  # CLAWDBOT GATEWAY SERVICE
  services.clawdbot = {
    enable = true;
    port = 3000;
    openFirewall = true;
    environmentFile = config.sops.templates."clawdbot-env".path;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "25.05";
}
