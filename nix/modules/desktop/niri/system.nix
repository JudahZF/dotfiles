{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  programs.niri.enable = true;

  # Niri provides X11 compatibility through xwayland-satellite. Steam still
  # needs X11 for its updater/login windows, so keep the satellite available in
  # the session PATH as well as referenced explicitly from config.kdl.
  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
