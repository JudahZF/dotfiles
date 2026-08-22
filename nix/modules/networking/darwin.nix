{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "angry-ip-scanner"
    "barrier"
    "nomachine"
    "unifi-identity-endpoint"
    "wifiman"
    "windows-app"
    "wireshark-app"
  ];
}
