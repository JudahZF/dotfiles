{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
lib.mkIf (pkgs.stdenv.isLinux && inputs.helium-browser.packages ? ${system}) {
  environment.systemPackages = [ inputs.helium-browser.packages.${system}.helium ];
}
