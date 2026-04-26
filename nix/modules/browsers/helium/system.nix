{
  pkgs,
  inputs,
  lib,
  ...
}:
lib.mkIf (pkgs.stdenv.isLinux && inputs.helium-browser.packages ? ${pkgs.system}) {
  environment.systemPackages = [ inputs.helium-browser.packages.${pkgs.system}.helium ];
}
