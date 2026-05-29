{
  dotfiles,
  pkgs,
  pkgs-unstable ? null,
  ...
}:
{
  programs = {
    ghostty = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then pkgs-unstable.ghostty-bin else pkgs.ghostty;
      settings = {
        background-opacity = 0.65;
        background-blur = "macos-glass-clear";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      envExtra =
        if pkgs.stdenv.isDarwin then
          builtins.readFile "${dotfiles}/zsh/macos/zshenv"
        else
          builtins.readFile "${dotfiles}/zsh/linux/zshenv";
      profileExtra =
        if pkgs.stdenv.isDarwin then builtins.readFile "${dotfiles}/zsh/macos/zprofile" else "";
      initContent =
        if pkgs.stdenv.isDarwin then
          builtins.readFile "${dotfiles}/zsh/macos/zshrc"
        else
          builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
