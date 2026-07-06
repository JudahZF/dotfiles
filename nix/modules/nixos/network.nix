{
  pkgs,
  lib,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
    };
    networkmanager = {
      enable = true;
      settings.main.no-auto-default = "*";
    };
  };
}
