{ pkgs, lib, ... }:

# Disabled until nixpkgs can provide meshtastic without the insecure python ecdsa
# dependency (CVE-2024-23342). Do not permit insecure packages globally.
lib.mkIf pkgs.stdenv.isLinux {
  environment.systemPackages = [ ];
}
