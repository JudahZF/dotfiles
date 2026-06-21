{ osConfig ? null, ... }:
let
  hostname =
    if osConfig == null then "" else osConfig.networking.hostName or "";
  defaultIdentityFile =
    if hostname == "popper" then "~/.ssh/work" else "~/.ssh/personal";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IdentityFile = defaultIdentityFile;
        SetEnv = { TERM = "xterm-256color"; };

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
      "personalgit codeberg.org" = {
        HostName = "codeberg.org";
        User = "git";
        IdentityFile = "~/.ssh/personal";
        IdentitiesOnly = true;
      };
      workgit = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/work";
        IdentitiesOnly = true;
      };
    };
  };
}
