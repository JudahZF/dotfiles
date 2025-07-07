{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  homebrew = {
    casks = [
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "autodesk-fusion"
      "pika"
    ];
  };
}
