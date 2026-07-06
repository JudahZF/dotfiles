{
  self,
  dotfiles,
  pkgs,
  ...
}:
{
  imports = [
    self.homeModules.home
    self.homeModules.utilities
  ];

  home = {
    username = "bigchurch";
    homeDirectory = "/home/bigchurch";
    packages = with pkgs; [
      google-chrome
      libreoffice-qt6-fresh
      haruna
      kdePackages.okular
      kdePackages.gwenview
      kdePackages.ark
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    envExtra = builtins.readFile "${dotfiles}/zsh/linux/zshenv";
    initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
  };
}
