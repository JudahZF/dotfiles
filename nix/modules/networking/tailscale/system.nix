{
  config,
  dotfiles,
  lib,
  pkgs,
  ...
}:
let
  secretSource = dotfiles + "/secrets/tailscale.yaml";
  hasAuthKey = builtins.pathExists secretSource;
  secretPath = config.sops.secrets.tailscale-auth-key.path;
  enroll = pkgs.writeShellApplication {
    name = "tailscale-enroll";
    runtimeInputs = [
      pkgs.jq
      pkgs.tailscale
    ];
    text = ''
      state="$(tailscale status --json | jq -er '.BackendState')" || exit 1

      case "$state" in
        Running)
          exit 0
          ;;
        NeedsLogin|NoState|Stopped)
          tailscale up "--auth-key=file:${secretPath}"
          test "$(tailscale status --json | jq -er '.BackendState')" = Running
          ;;
        *)
          exit 1
          ;;
      esac
    '';
  };
in
lib.mkMerge [
  { services.tailscale.enable = true; }
  (lib.mkIf hasAuthKey {
    sops = {
      useSystemdActivation = true;
      secrets.tailscale-auth-key = {
        sopsFile = secretSource;
        key = "auth_key";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    systemd.services.tailscale-enroll = {
      description = "Enroll Tailscale once this boot";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "sops-install-secrets.service"
        "tailscaled.service"
      ];
      requires = [
        "network-online.target"
        "sops-install-secrets.service"
        "tailscaled.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe enroll;
        Restart = "on-failure";
        RestartSec = "10s";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    };
  })
]
