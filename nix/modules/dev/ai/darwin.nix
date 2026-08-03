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
    casks = [
      "cursor"
      "cursor-cli"
      "codex"
      "codex-app"
      "steipete/tap/codexbar"
    ];
  };
}
