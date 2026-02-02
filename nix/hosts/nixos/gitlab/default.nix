{ pkgs, lib, inputs, config, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../../modules/system/nixos/ssh.nix
    ./../../../modules/system/nixos/tailscale.nix
    ./../../../modules/system/nixos/network.nix
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
    defaultSopsFile = lib.mkForce "${dotfiles}/secrets/gitlab.yaml";

    secrets = {
      "smb/username" = {
        owner = "root";
        group = "root";
        mode = "0600";
      };
      "smb/password" = {
        owner = "root";
        group = "root";
        mode = "0600";
      };
      "secret" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "otp" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "db" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "initialRootPassword" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "activeRecordPrimaryKey" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "activeRecordDeterministicKey" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
      "activeRecordSalt" = {
        owner = "gitlab";
        group = "gitlab";
        mode = "0640";
      };
    };

    templates."smb-credentials" = {
      content = ''
        username=${config.sops.placeholder."smb/username"}
        password=${config.sops.placeholder."smb/password"}
      '';
      mode = "0600";
    };
  };

  # NETWORK
  networking = {
    hostName = "gitlab";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.30";
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
    extraGroups = [ "wheel" "docker" ];
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
    btrfs-progs
    git
    wget
    zsh
    htop
    vim
    tmux
    cifs-utils
  ];

  systemd.tmpfiles.rules = [
    "d /git 0755 git gitlab -"
    "d /var/gitlab/state 0750 gitlab gitlab -"
  ];

  fileSystems."/git" = {
    device = "//192.168.10.5/git";
    fsType = "cifs";
    options = [
      "credentials=${config.sops.templates."smb-credentials".path}"
      "uid=${toString config.users.users.git.uid}"
      "gid=${toString config.users.groups.gitlab.gid}"
      "file_mode=0664"
      "dir_mode=0775"
      "noperm"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  users.users.git = {
    uid = lib.mkForce 986;
    group = "git";
  };
  users.groups.git = {};
  users.groups.gitlab.gid = lib.mkForce 986;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.qemuGuest.enable = true;

  # GITLAB CONFIGURATION
  services.gitlab = {
    enable = true;
    host = "gitlab.local";
    port = 80;
    https = false;
    statePath = "/var/gitlab/state";

    secrets = {
      secretFile = config.sops.secrets."secret".path;
      otpFile = config.sops.secrets."otp".path;
      dbFile = config.sops.secrets."db".path;
      jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
      activeRecordPrimaryKeyFile = config.sops.secrets."activeRecordPrimaryKey".path;
      activeRecordDeterministicKeyFile = config.sops.secrets."activeRecordDeterministicKey".path;
      activeRecordSaltFile = config.sops.secrets."activeRecordSalt".path;
    };

    initialRootPasswordFile = config.sops.secrets."initialRootPassword".path;

    databaseCreateLocally = true;
    databaseHost = "";
    databasePasswordFile = null;

    redisUrl = "unix:/run/gitlab/redis.sock";

    extraConfig = {
      gitlab = {
        email_from = "gitlab@example.com";
        email_display_name = "GitLab";
        email_reply_to = "noreply@example.com";
        default_projects_features = {
          issues = true;
          merge_requests = true;
          wiki = true;
          snippets = true;
          builds = true;
          container_registry = true;
        };
      };

      backup = {
        keep_time = 604800;
        path = "/git/gitlab-backups";
      };

      repositories = {
        storages = {
          default = {
            path = "/git/gitlab/repositories";
          };
        };
      };
    };
  };

  systemd.services.gitlab.after = [ "git.mount" ];
  systemd.services.gitlab.wants = [ "git.mount" ];

  systemd.services.gitlab-workhorse = {
    wants = [ "git.mount" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."gitlab.local" = {
      enableACME = false;
      forceSSL = false;

      locations."/" = {
        proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 250m;
          proxy_read_timeout 3600;
          proxy_connect_timeout 300;
        '';
      };
    };
  };

  services.redis.servers.gitlab = {
    enable = true;
    unixSocket = "/run/gitlab/redis.sock";
    unixSocketPerm = 770;
  };

  services.postgresql = {
    enable = true;
    settings = {
      shared_buffers = "256MB";
      effective_cache_size = "768MB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };

  system.stateVersion = "25.05";
}
