{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  networking = {
    firewall.enable = false;
    networkmanager = {
      enable = true;
      settings.main.no-auto-default = "*";
    };
  };
}
