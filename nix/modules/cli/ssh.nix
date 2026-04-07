{ ... }: {
  programs.ssh = {
    matchBlocks = {
      all = {
        match = "*";
        setEnv = "TERM=xterm-256color";
        IdentityAgent = "~/.1password/agent.sock";
      };
      personalgit = {
        host = "personalgit";
        hostName = "github.com";
        user = "git";
        IdentityFile = "~/.ssh/personal.pub";
        IdentitiesOnly = "yes";
      };
      workgit = {
        host = "workgit";
        hostName = "github.com";
        user = "git";
        IdentityFile = "~/.ssh/work.pub";
        IdentitiesOnly = "yes";
      };
    };
  };
}
