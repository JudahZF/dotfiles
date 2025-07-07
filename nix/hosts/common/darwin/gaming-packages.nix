{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  homebrew = {
    casks = [
      "curseforge"
      "minecraft"
      "steam"
    ];
  };
}
