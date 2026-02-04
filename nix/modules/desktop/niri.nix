{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  programs.niri = {
    enable = true;
  };

  # xwayland-satellite provides XWayland support for niri
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # Enable xdg-desktop-portal for proper Wayland integration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
