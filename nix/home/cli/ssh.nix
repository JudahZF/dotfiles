{ ... }: {
  programs.ssh = {
    matchBlocks.all = {
      match = "*";
      setEnv = "TERM=xterm-256color";
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}
