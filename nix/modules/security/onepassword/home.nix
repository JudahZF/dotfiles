{ pkgs, lib, ... }:
lib.mkMerge [
  {
    home.sessionVariables = { SSH_AUTH_SOCK = "$HOME/.1password/agent.sock"; };
    home.packages = with pkgs; [ _1password-cli ];
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.activation.onepasswordAgentSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.1password"
      ln -sf "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
        "$HOME/.1password/agent.sock"
    '';
  })
  (lib.mkIf pkgs.stdenv.isLinux {
    systemd.user.services._1password-agent = {
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

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  })
]
