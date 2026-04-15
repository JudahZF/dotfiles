{ pkgs, inputs, lib, ... }:
lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isDarwin {
    homebrew.casks = [ "helium-browser" ];
  })
  (lib.mkIf (!pkgs.stdenv.isDarwin && inputs.helium-browser.packages ? ${pkgs.system}) {
    environment.systemPackages = [ inputs.helium-browser.packages.${pkgs.system}.helium ];
  })
]
