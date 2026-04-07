{ pkgs, inputs, lib, ... }:
lib.mkIf (inputs.helium-browser.packages ? ${pkgs.system}) {
  environment.systemPackages = [ inputs.helium-browser.packages.${pkgs.system}.default ];
}
