# NixOS module for Clawdbot AI gateway service
# Only import this module on NixOS hosts that need it
{ config, lib, pkgs, ... }:

let
  cfg = config.services.clawdbot;
in {
  options.services.clawdbot = {
    enable = lib.mkEnableOption "Clawdbot AI gateway";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nodePackages.clawdbot or (
        pkgs.stdenv.mkDerivation {
          pname = "clawdbot-placeholder";
          version = "0.0.0";
          dontUnpack = true;
          installPhase = "mkdir -p $out";
        }
      );
      description = "The clawdbot package to use (installed via npm if not in nixpkgs)";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "clawdbot";
      description = "User account under which clawdbot runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "clawdbot";
      description = "Group under which clawdbot runs";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/clawdbot";
      description = "Directory for clawdbot data and configuration";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port for the clawdbot gateway to listen on";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for clawdbot";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Environment file containing secrets (ANTHROPIC_API_KEY, etc.)";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs_22
      nodePackages.npm
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      description = "Clawdbot gateway service user";
    };
    users.groups.${cfg.group} = {};

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/.config 0750 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.clawdbot = {
      description = "Clawdbot AI Gateway";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = cfg.dataDir;
        NODE_ENV = "production";
        CLAWDBOT_PORT = toString cfg.port;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStartPre = pkgs.writeShellScript "clawdbot-install" ''
          export HOME=${cfg.dataDir}
          export PATH=${pkgs.nodejs_22}/bin:${pkgs.nodePackages.npm}/bin:$PATH
          if [ ! -f ${cfg.dataDir}/node_modules/.bin/clawdbot ]; then
            cd ${cfg.dataDir}
            ${pkgs.nodePackages.npm}/bin/npm install clawdbot@latest
          fi
        '';
        ExecStart = pkgs.writeShellScript "clawdbot-start" ''
          export HOME=${cfg.dataDir}
          export PATH=${pkgs.nodejs_22}/bin:${cfg.dataDir}/node_modules/.bin:$PATH
          exec ${cfg.dataDir}/node_modules/.bin/clawdbot gateway
        '';
        Restart = "on-failure";
        RestartSec = "10s";

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ReadWritePaths = [ cfg.dataDir ];
      } // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
