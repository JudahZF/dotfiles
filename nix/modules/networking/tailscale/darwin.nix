{
  config,
  dotfiles,
  lib,
  pkgs,
  username,
  ...
}:
let
  secretSource = dotfiles + "/secrets/tailscale.yaml";
  hasAuthKey = builtins.pathExists secretSource;
  secretPath = config.sops.secrets.tailscale-auth-key.path;
  enroll = pkgs.writeShellApplication {
    name = "tailscale-enroll";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
      test -x "$tailscale" || exit 1
      /usr/bin/open -gj -a Tailscale || exit 1

      state="$(TAILSCALE_BE_CLI=1 "$tailscale" status --json | jq -er '.BackendState')" || exit 1

      case "$state" in
        Running)
          exit 0
          ;;
        NeedsLogin|NoState|Stopped)
          TAILSCALE_BE_CLI=1 "$tailscale" up "--auth-key=file:${secretPath}"
          test "$(TAILSCALE_BE_CLI=1 "$tailscale" status --json | jq -er '.BackendState')" = Running
          ;;
        *)
          exit 1
          ;;
      esac
    '';
  };
in
lib.mkIf pkgs.stdenv.isDarwin (
  lib.mkMerge [
    { homebrew.casks = [ "tailscale-app" ]; }
    (lib.mkIf hasAuthKey {
      sops.secrets.tailscale-auth-key = {
        sopsFile = secretSource;
        key = "auth_key";
        owner = username;
        group = "staff";
        mode = "0400";
      };

      launchd.user.agents.tailscale-enroll.serviceConfig = {
        ProgramArguments = [ (lib.getExe enroll) ];
        EnvironmentVariables = {
          HOME = "/Users/${username}";
          PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
          TAILSCALE_BE_CLI = "1";
        };
        RunAtLoad = true;
        KeepAlive.SuccessfulExit = false;
        ThrottleInterval = 10;
        ProcessType = "Background";
        StandardOutPath = "/tmp/tailscale-enroll_${username}.out.log";
        StandardErrorPath = "/tmp/tailscale-enroll_${username}.err.log";
      };
    })
  ]
)
