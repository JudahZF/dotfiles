{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gimp
    kicad
    prusaslicer
  ];
}
