{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [ ".env" ];
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO";
      signByDefault = true;
    };
    settings = {
      user = {
        email = "judah@judahfuller.com";
        name = "Judah Fuller";
      };
      gpg.ssh.program =
        if pkgs.stdenv.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      diff.tool = "difftastic";
      difftool.prompt = false;
      difftool.difftastic.cmd = ''${lib.getExe pkgs.difftastic} "$LOCAL" "$REMOTE"'';
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
      rebase.autoStash = true;
      fetch.prune = true;
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        glog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        gloga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        amend = "commit --amend --no-edit";
        wip = "commit -am 'WIP'";
        undo = "reset HEAD~1 --mixed";
        unstage = "reset HEAD --";
        discard = "checkout --";
        recent = "branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
        cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
        last = "log -1 HEAD";
        history = "log --oneline -20";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
