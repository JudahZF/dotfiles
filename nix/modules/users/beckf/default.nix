{ self, dotfiles, ... }: {
  imports = [
    self.homeModules.home
    self.homeModules.utilities
  ];

  home = {
    username = "beckf";
    homeDirectory = "/home/beckf";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    envExtra = builtins.readFile "${dotfiles}/zsh/linux/zshenv";
    initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
  };
}
