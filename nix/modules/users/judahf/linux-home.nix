{ dotfiles, pkgs, ... }:
{
  programs = {
    ghostty = {
      enable = pkgs.stdenv.isLinux;
      settings.background-opacity = 0.5;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      envExtra =
        if pkgs.stdenv.isDarwin then
          builtins.readFile "${dotfiles}/zsh/macos/zshenv"
        else
          builtins.readFile "${dotfiles}/zsh/linux/zshenv";
      initContent =
        if pkgs.stdenv.isDarwin then
          builtins.readFile "${dotfiles}/zsh/macos/zshrc"
        else
          builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
