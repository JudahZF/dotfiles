{ lib, pkgs, ... }: {
  # 1Password SSH Agent configuration for home-manager

  # Set environment variable for 1Password SSH agent socket
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  # Ensure 1Password CLI is available in the user environment
  home.packages = with pkgs; [
    _1password-cli
  ];

  # Configure systemd user service to run 1Password SSH agent on NixOS
  systemd.user.services._1password-agent = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "1Password SSH Agent";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      Restart = "on-failure";
      RestartSec = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
