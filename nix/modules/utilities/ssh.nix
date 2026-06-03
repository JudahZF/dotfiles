{ osConfig ? null, ... }:
let
  hostname = if osConfig == null then "" else osConfig.networking.hostName or "";
  defaultIdentityFile = if hostname == "popper" then "~/.ssh/work" else "~/.ssh/personal";
in
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*" = {
        identityFile = defaultIdentityFile;
        setEnv = { TERM = "xterm-256color"; };
      };
      personalgit = {
        host = "personalgit codeberg.org";
        hostname = "codeberg.org";
        user = "git";
        identityFile = "~/.ssh/personal";
        identitiesOnly = true;
      };
      workgit = {
        host = "workgit";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/work";
        identitiesOnly = true;
      };
    };
  };
}
