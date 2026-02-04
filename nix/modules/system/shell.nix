{ pkgs, ... }: {
  environment = {
    shellAliases = {
      cc = "claude --dangerously-skip-permissions";

      diff = "difftastic";
      du = "dua";
      find = "fd";
      grep = "rg";
      neofetch = "fastfetch";
      top = "btop";
      watch = "entr";
    };
    systemPackages = with pkgs; [
      bash # backup shell
      btop # top
      comma # nix commands
      coreutils # uutils rust
      curl # download
      difftastic # diff
      dua # du
      entr # watch
      fastfetch # neofetch
      fd # find
      fzf # fuzzy finder
      just # command runner
      ripgrep # grep
      starship # shell prompt
      unzip # unzip
      wget # download
      zellij # tmux
      zoxide # cd
      zsh # main shell
    ];
  };
}
