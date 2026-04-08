{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = [
    (pkgs.python313.withPackages (ps: [ ps.meshtastic ]))
  ];
}
