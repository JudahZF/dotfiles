{
  config,
  lib,
  osConfig ? null,
  ...
}:
let
  hostname = if osConfig == null then "" else osConfig.networking.hostName or "";
  defaultIdentityFile = if hostname == "popper" then "~/.ssh/work" else "~/.ssh/personal";
  sshConfig = config.home.file.".ssh/config".source;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityFile = defaultIdentityFile;
        SetEnv = {
          TERM = "xterm-256color";
        };

        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
      "192.168.1.33" = {
        User = "judahf";
        IdentityFile = "~/.ssh/work";
      };
      workgit = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/work";
        IdentitiesOnly = true;
      };
    };
  };

  # OpenSSH rejects Nix store ownership inside sandboxed tools such as t3code.
  # Materialize the generated config as a user-owned file after Home Manager
  # links the generation into place.
  home.file.".ssh/config".force = true;
  home.activation.materializeSshConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run install -m 600 ${sshConfig} "$HOME/.ssh/.config.home-manager"
    run mv -f "$HOME/.ssh/.config.home-manager" "$HOME/.ssh/config"
  '';
}
