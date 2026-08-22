{ pkgs, lib, ... }:
# meshtastic is intentionally absent: nixpkgs cannot yet build it without the
# insecure python ecdsa dependency (CVE-2024-23342), and we do not permit
# insecure packages globally.
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = with pkgs; [
    signal-cli
    signal-desktop
  ];
}
