{ config, username, ... }:
{
  homebrew = {
    brews = [ "cliproxyapi" ];
    casks = [
      "cursor"
      "cursor-cli"
      "codex"
      "codex-app"
      # Disabled because the upstream Homebrew cask currently points at a 404
      # ToDesktop build URL, which makes `darwin-rebuild switch` fail.
      # "comfyui"
      "lm-studio"
      "steipete/tap/codexbar"
    ];
  };

  environment.etc."cliproxyapi.conf".text = ''
    host: "127.0.0.1"
    port: 8317
    auth-dir: "/Users/${username}/.cli-proxy-api"
    api-keys:
      - "sk-localhost"
    remote-management:
      allow-remote: false
      secret-key: ""
      disable-control-panel: true
  '';

  launchd.user.agents.cliproxyapi.serviceConfig = {
    ProgramArguments = [
      "${config.homebrew.prefix}/bin/cliproxyapi"
      "--config"
      "/etc/cliproxyapi.conf"
    ];
    KeepAlive = true;
    RunAtLoad = true;
  };
}
