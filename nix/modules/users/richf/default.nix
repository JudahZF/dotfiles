{ self, dotfiles, ... }: {
  imports = [
    self.homeModules.home
    self.homeModules.cli
  ];

  home = {
    username = "richf";
    homeDirectory = "/home/richf";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    envExtra = builtins.readFile "${dotfiles}/zsh/linux/zshenv";
    initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
  };
}
