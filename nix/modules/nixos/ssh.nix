{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isLinux {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Personal key is the baseline for every NixOS host. Host-specific keys (for
  # example the work key on popper) are added in that host's configuration.
  users.users.judahf.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO"
  ];
}
