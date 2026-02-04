{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      hide_f1_commands = true;
      clock = "%Y-%m-%d %H:%M";
    };
  };
}
