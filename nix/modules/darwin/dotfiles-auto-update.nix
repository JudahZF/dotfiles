{
  config,
  dotfiles,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.services.dotfilesAutoUpdate;
  statePath = "/Users/${username}/Library/Application Support/dotfiles-auto-update";
  flakeRef = "${cfg.repository}/nix#${config.networking.hostName}";
  sudoFlakeRef = lib.replaceStrings [ "#" ] [ "\\#" ] flakeRef;
  notify = pkgs.writeShellApplication {
    name = "notify-dotfiles-auto-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
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
in
{
  options.services.dotfilesAutoUpdate = {
    enable = lib.mkEnableOption "safe automatic dotfiles updates";

    repository = lib.mkOption {
      type = lib.types.str;
      default = "/Users/${username}/dotfiles";
      description = "Path to the editable dotfiles checkout.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      description = "Approved branch to consume.";
    };

    expectedRemote = lib.mkOption {
      type = lib.types.str;
      default = "ssh://git@codeberg.org/JudahZF/dotfiles.git";
      description = "Exact origin URL required before an automatic update.";
    };

    interval = lib.mkOption {
      type = lib.types.ints.positive;
      default = 3600;
      description = "Seconds between update attempts while the user is logged in.";
    };
  };

  config = lib.mkIf cfg.enable {
    security.sudo.extraConfig = lib.mkAfter ''
      ${username} ALL = (root) NOPASSWD: NOSETENV: /run/current-system/sw/bin/darwin-rebuild switch --flake ${sudoFlakeRef} --max-jobs 1 --cores 1
      ${username} ALL = (root) NOPASSWD: NOSETENV: /run/current-system/sw/bin/darwin-rebuild switch --flake ${cfg.repository}/nix --max-jobs auto --cores 0
    '';

    launchd.user.agents.dotfiles-auto-update.serviceConfig = {
      Label = "org.judahfuller.dotfiles-auto-update";
      ProgramArguments = [
        (lib.getExe apply)
        "--repo"
        cfg.repository
        "--branch"
        cfg.branch
        "--remote-url"
        cfg.expectedRemote
        "--flake-ref"
        flakeRef
        "--state-dir"
        statePath
        "--notify-command"
        (lib.getExe notify)
        "--rebuild-command"
        (lib.getExe rebuild)
      ];
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/${username}/bin:/Users/${username}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      WorkingDirectory = cfg.repository;
      RunAtLoad = true;
      StartInterval = cfg.interval;
      ProcessType = "Background";
      Nice = 19;
      LowPriorityIO = true;
      ThrottleInterval = 300;
      StandardOutPath = "/Users/${username}/Library/Logs/dotfiles-auto-update.out.log";
      StandardErrorPath = "/Users/${username}/Library/Logs/dotfiles-auto-update.err.log";
    };
  };
}
