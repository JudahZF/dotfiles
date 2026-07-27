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
  operatorFlag = "--operator=judahf";
  enroll = pkgs.writeShellApplication {
    name = "tailscale-enroll";
    runtimeInputs = [
      pkgs.jq
      pkgs.tailscale
    ];
    text = ''
      retries=0
      while (( retries < 10 )); do
        state="$(tailscale status --json | jq -er '.BackendState')" || state=NoState
        if [[ "$state" == Running ]]; then
          exit 0
        fi

        (( retries += 1 ))
        sleep 1
      done

      case "$state" in
        NeedsLogin|NoState|Stopped)
          tailscale up "--auth-key=file:${secretPath}" ${operatorFlag}
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
  {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ operatorFlag ];
    };
  }
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
