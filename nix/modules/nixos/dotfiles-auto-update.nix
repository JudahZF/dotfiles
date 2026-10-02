{
  config,
  dotfiles,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dotfilesAutoUpdate;
  userHome = config.users.users.${cfg.user}.home;
  repository = if cfg.repository == null then "${userHome}/dotfiles" else cfg.repository;
  statePath = "${userHome}/.local/state/dotfiles-auto-update";
  notify = pkgs.writeShellApplication {
    name = "notify-dotfiles-auto-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
      pkgs.libnotify
    ];
    text = builtins.readFile (dotfiles + "/scripts/notify-dotfiles-auto-update.sh");
  };
  rebuild = pkgs.writeShellApplication {
    name = "dotfiles-auto-rebuild";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.flock
      pkgs.nix
    ];
    text = builtins.readFile (dotfiles + "/nix/_internal_rebuild.sh");
  };
  apply = pkgs.writeShellApplication {
    name = "apply-approved-dotfiles";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.flock
      pkgs.git
      pkgs.inetutils
      pkgs.openssh
    ];
    text = builtins.readFile (dotfiles + "/scripts/apply-approved-dotfiles.sh");
  };
  flushNotification = pkgs.writeShellScript "flush-dotfiles-auto-update-notification" ''
    if [ "$(${pkgs.coreutils}/bin/id -un)" = ${lib.escapeShellArg cfg.user} ]; then
      exec ${lib.getExe notify} --state-dir ${lib.escapeShellArg statePath} --flush
    fi
  '';
in
{
  options.services.dotfilesAutoUpdate = {
    enable = lib.mkEnableOption "safe automatic dotfiles updates";

    repository = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the editable dotfiles checkout; defaults to the selected user's home.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "judahf";
      description = "User that owns the checkout and performs the update.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Approved branch to consume.";
    };

    expectedRemote = lib.mkOption {
      type = lib.types.str;
      default = "https://github.com/JudahZF/dotfiles.git";
      description = "Exact origin URL required before an automatic update.";
    };

    bootDelay = lib.mkOption {
      type = lib.types.str;
      default = "10min";
      description = "Delay after boot before the first update attempt.";
    };

    interval = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "1h";
      description = "Delay after a completed run before retrying, or null for boot-only.";
    };

    randomizedDelay = lib.mkOption {
      type = lib.types.str;
      default = "10min";
      description = "Random delay added to update timer runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.hasAttr cfg.user config.users.users;
        message = "services.dotfilesAutoUpdate.user must name a configured user";
      }
    ];

    systemd = {
      services.dotfiles-auto-update = {
        description = "Safely pull and activate approved dotfiles updates";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        restartIfChanged = false;
        environment.HOME = userHome;
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          WorkingDirectory = repository;
          Nice = 19;
          CPUWeight = 10;
          IOWeight = 10;
          IOSchedulingClass = "idle";
          IOSchedulingPriority = 7;
          TimeoutStartSec = "6h30min";
        };
        script = ''
          exec ${lib.getExe apply} \
            --repo ${lib.escapeShellArg repository} \
            --branch ${lib.escapeShellArg cfg.branch} \
            --remote-url ${lib.escapeShellArg cfg.expectedRemote} \
            --flake-ref ${lib.escapeShellArg "${repository}/nix#${config.networking.hostName}"} \
            --state-dir ${lib.escapeShellArg statePath} \
            --notify-command ${lib.escapeShellArg (lib.getExe notify)} \
            --rebuild-command ${lib.escapeShellArg (lib.getExe rebuild)}
        '';
      };

      timers.dotfiles-auto-update = {
        description = "Schedule approved dotfiles updates";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = cfg.bootDelay;
          RandomizedDelaySec = cfg.randomizedDelay;
          Unit = "dotfiles-auto-update.service";
        }
        // lib.optionalAttrs (cfg.interval != null) {
          OnUnitInactiveSec = cfg.interval;
        };
      };

      user.services.dotfiles-auto-update-notify = {
        description = "Deliver pending dotfiles update notifications";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = flushNotification;
        };
      };
    };
  };
}
