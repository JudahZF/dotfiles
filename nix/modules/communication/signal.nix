{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = with pkgs; [
    signal-cli
    signal-desktop
  ];
}
