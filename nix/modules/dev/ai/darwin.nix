{
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
    brews = [ "jundot/omlx/omlx" ];
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
}
