{ ... }: {
  programs.ssh = {
    matchBlocks = {
      "*" = { setEnv = { TERM = "xterm-256color"; }; };
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
        identityFile = "~/.ssh/work.pub";
        identitiesOnly = true;
      };
    };
  };
}
