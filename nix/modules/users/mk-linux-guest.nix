{
  username,
  extraPackages ? (_pkgs: [ ]),
}:
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
    inherit username;
    homeDirectory = "/home/${username}";
    packages = extraPackages pkgs;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    envExtra = builtins.readFile "${dotfiles}/zsh/linux/zshenv";
    initContent = builtins.readFile "${dotfiles}/zsh/linux/zshrc";
  };
}
