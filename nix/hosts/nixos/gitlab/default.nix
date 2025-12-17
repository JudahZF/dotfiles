{ pkgs, inputs, config, dotfiles, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../common/nixOS/system/bootloader.nix
    ./../../common/nixOS/system/ssh.nix
    ./../../common/nixOS/system/tailscale.nix
    ./../../common/nixOS/system/network.nix
    ./../../common/all/system/nix.nix
    ./../../common/all/system/nixpkgs.nix
    ./../../common/all/system/sops.nix
  ];

  # SOPS SECRETS CONFIGURATION
  sops = {
    defaultSopsFile = "${dotfiles}/secrets/gitlab";

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
        owner = "git";
        group = "gitlab";
      };
      "otp" = {
        owner = "git";
        group = "gitlab";
      };
      "db" = {
        owner = "git";
        group = "gitlab";
      };
    };

    # Template for SMB credentials file
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
    # Configure with static IP or DHCP as needed
    # Uncomment and modify for static IP:
    # interfaces.ens18 = {
    #   useDHCP = false;
    #   ipv4.addresses = [{
    #     address = "192.168.10.30";
    #     prefixLength = 24;
    #   }];
    # };
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
      # Add your SSH public key here
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable password-less sudo for wheel group
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
    cifs-utils  # Required for SMB mounts
  ];

  # Create /git directory and mount SMB share
  systemd.tmpfiles.rules = [
    "d /git 0755 git gitlab -"
  ];

  fileSystems."/git" = {
    device = "//192.168.10.5/git";
    fsType = "cifs";
    options = [
      "username=${builtins.readFile config.sops.secrets.smb_username.path}"
      "password=${builtins.readFile config.sops.secrets.smb_password.path}"
      "uid=${toString config.users.users.git.uid}"
      "gid=${toString config.users.groups.gitlab.gid}"
      "file_mode=0660"
      "dir_mode=0770"
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  # Ensure git user has a fixed UID for SMB mount
  users.users.git.uid = 986;
  users.groups.gitlab.gid = 986;

  programs.zsh.enable = true;
  nixpkgs.config.allowUnfree = true;

  # GITLAB CONFIGURATION
  services.gitlab = {
    enable = true;

    # Set your GitLab host - update this to your domain
    host = "gitlab.local";
    port = 443;
    https = true;

    # Use SMB mount for git repository storage
    statePath = "/git/gitlab";

    # Secret files - now managed by SOPS
    secrets = {
      secretFile = config.sops.secrets."secret".path;
      otpFile = config.sops.secrets."otp".path;
      dbFile = config.sops.secrets."db".path;
      jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
    };

    # Database configuration
    databaseCreateLocally = true;
    databaseHost = "";
    databasePasswordFile = null;

    # Redis configuration
    redisUrl = "unix:/run/gitlab/redis.sock";

    # SMTP configuration - uncomment and configure for email
    # smtp = {
    #   enable = true;
    #   address = "smtp.example.com";
    #   port = 587;
    #   username = "gitlab@example.com";
    #   passwordFile = "/run/secrets/smtp-password";
    #   domain = "example.com";
    #   authentication = "login";
    #   enableStartTlsAuto = true;
    # };

    # GitLab settings
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

      # Backup settings
      backup = {
        keep_time = 604800; # 7 days in seconds
        path = "/git/gitlab-backups";
      };

      # Git repository storage
      repositories = {
        storages = {
          default = {
            path = "/git/gitlab/repositories";
          };
        };
      };
    };
  };

  # Ensure GitLab service starts after the SMB mount and SOPS secrets
  systemd.services.gitlab.after = [ "git.mount" ];
  systemd.services.gitlab.requires = [ "git.mount" ];
  systemd.services.gitlab-workhorse.after = [ "git.mount" ];
  systemd.services.gitlab-workhorse.requires = [ "git.mount" ];

  # NGINX reverse proxy for GitLab
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."gitlab.local" = {
      enableACME = false;
      forceSSL = false;

      # Use self-signed cert for local development
      # For production, enable ACME or provide your own certs
      # enableACME = true;
      # forceSSL = true;

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

  # Redis for GitLab
  services.redis.servers.gitlab = {
    enable = true;
    unixSocket = "/run/gitlab/redis.sock";
    unixSocketPerm = 770;
  };

  # PostgreSQL tuning for GitLab
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

  # Open firewall for HTTP/HTTPS and SSH
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Docker for GitLab CI runners (optional)
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable automatic updates (optional)
  system.autoUpgrade = {
    enable = false; # Set to true if you want automatic updates
    allowReboot = false;
  };

  system.stateVersion = "25.05";
}
