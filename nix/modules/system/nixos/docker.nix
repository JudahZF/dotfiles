{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
