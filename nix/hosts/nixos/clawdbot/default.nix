{ pkgs, lib, inputs, config, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../common/nixOS/system/ssh.nix
    ./../../common/nixOS/system/tailscale.nix
    ./../../common/nixOS/system/network.nix
    ./../../common/nixOS/apps/clawdbot.nix
    ./../../common/all/system/nix.nix
    ./../../common/all/system/nixpkgs.nix
    ./../../common/all/system/sops.nix
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

    # Environment file template for clawdbot service
    templates."clawdbot-env" = {
      content = ''
        ANTHROPIC_API_KEY=${config.sops.placeholder."anthropic_api_key"}
      '';
      owner = "clawdbot";
      group = "clawdbot";
      mode = "0640";
    };
  };

  # NETWORK - Update IP address as needed
  networking = {
    hostName = "clawdbot";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.31";  # Update this IP
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
        ./../../../home/judahf.nix
      ];
    };
  };

  # Enable password-less sudo for wheel group
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

  # QEMU Guest Agent (for Proxmox)
  services.qemuGuest.enable = true;

  # CLAWDBOT GATEWAY SERVICE
  services.clawdbot = {
    enable = true;
    port = 3000;
    openFirewall = true;
    environmentFile = config.sops.templates."clawdbot-env".path;
  };

  # Open firewall for SSH
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "25.05";
}
