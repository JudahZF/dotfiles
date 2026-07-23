{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ "judahf" ];
      GSSAPIAuthentication = false;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
      PermitRootLogin = "no";
      UseDns = false;
      X11Forwarding = false;
    };
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "fc00::/7"
      "fe80::/10"
    ];
  };

  # Personal-machine convenience: passwordless sudo for judahf.
  # Scope to rebuild/deploy commands if these hosts leave a trusted network.
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = [ "judahf" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
