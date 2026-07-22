{
  config,
  username,
  pkgs,
  lib,
  ...
}:
let
  locallyUncensored = import ../../../packages/locally-uncensored.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = [ locallyUncensored ];

  homebrew = {
    brews = [
      "cliproxyapi"
      "jundot/omlx/omlx"
    ];
    casks = [
      "cursor"
      "cursor-cli"
      "codex"
      "codex-app"
      "comfy"
      "lm-studio"
      "ollama-app"
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
