{ dotfiles, pkgs, ... }: {
  imports = [
    ./apps
    ./cli
  ];
  home = {
    stateVersion = "24.05";
    username = "richf";
    homeDirectory = "/home/richf";
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
