{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  locallyUncensored = import ../../../packages/locally-uncensored.nix { inherit pkgs lib; };
  t3codeNightly = import ../../../packages/t3code.nix { inherit pkgs lib; };
  t3codeServer = pkgs.writeShellScript "t3code-server-start" ''
    until ${config.homebrew.prefix}/bin/tailscale status --json >/dev/null 2>&1; do
      /bin/sleep 2
    done

    while /usr/bin/nc -z 127.0.0.1 3773; do
      /bin/sleep 2
    done

    exec ${t3codeNightly}/bin/t3code-server \
      serve \
      --host 127.0.0.1 \
      --port 3773 \
      --base-dir /Users/${username}/.t3 \
      --tailscale-serve \
      --tailscale-serve-port 443
  '';
in
{
  environment.systemPackages = [ locallyUncensored ];

  homebrew = {
    casks = [
      "cursor"
      "cursor-cli"
      "codex"
      "codex-app"
      "steipete/tap/codexbar"
    ];
  };

  launchd.user.agents.t3code.serviceConfig = {
    Label = "com.judahfuller.t3code";
    ProgramArguments = [ "${t3codeServer}" ];
    EnvironmentVariables = {
      HOME = "/Users/${username}";
      PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/${username}/bin:/Users/${username}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${config.homebrew.prefix}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    };
    WorkingDirectory = "/Users/${username}";
    KeepAlive = true;
    RunAtLoad = true;
    ThrottleInterval = 10;
    StandardOutPath = "/Users/${username}/Library/Logs/t3code.out.log";
    StandardErrorPath = "/Users/${username}/Library/Logs/t3code.err.log";
  };
}
