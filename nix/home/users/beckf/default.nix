{ dotfiles, pkgs, ... }: {
  imports = [
    ../../apps
    ../../cli
  ];
  home = {
    stateVersion = "24.05";
    username = "beckf";
    homeDirectory = "/home/beckf";
    enableNixpkgsReleaseCheck = false;
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      envExtra = builtins.readFile "${dotfiles}/zsh/linux/zshenv";
      initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
