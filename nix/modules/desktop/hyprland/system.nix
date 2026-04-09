{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
}
