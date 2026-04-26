{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = with pkgs; [
    grim
    slurp
  ];
}
