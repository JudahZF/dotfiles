{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  users.users.judahf.linger = true;

  systemd.user.services.t3code =
    let
      t3codeNightly = import ../../../packages/t3code.nix { inherit pkgs lib; };
    in
    {
      description = "T3 Code server";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = [
          "${pkgs.tailscale}/bin/tailscale status --json"
          "${pkgs.runtimeShell} -c '! ${pkgs.netcat}/bin/nc -z 127.0.0.1 3773'"
        ];
        ExecStart = "${t3codeNightly}/bin/t3code-server serve --host 127.0.0.1 --port 3773 --base-dir /home/judahf/.t3 --tailscale-serve --tailscale-serve-port 443";
        Environment = [
          "HOME=/home/judahf"
          "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/judahf/bin:/home/judahf/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/wrappers/bin:/usr/bin:/bin"
          # Cursor SDK traffic goes through the CLIProxyAPI relay. The SDK reads this once
          # from the server process, so it cannot be set per provider instance. Set
          # CURSOR_API_KEY=<proxy key> on the Cursor instance in T3 settings.
          "CURSOR_BACKEND_URL=https://cliprox.tabby-ilish.ts.net/cursor"
        ];
        WorkingDirectory = "/home/judahf";
        Restart = "always";
        RestartSec = "10s";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
}
