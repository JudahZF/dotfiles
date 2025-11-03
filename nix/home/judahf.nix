{ dotfiles, pkgs, ... }: {
  imports = [ ./cli ./desktop ];
  home = { stateVersion = "24.05"; };

  programs = {
    ghostty = {
      enable = true;
      settings = { background-opacity = 0.8; };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      initContent = if pkgs.stdenv.isDarwin then
        builtins.readFile "${dotfiles}/zsh/macos/zshrc"
      else
        builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
