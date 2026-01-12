{ dotfiles, pkgs, ... }: {
  imports = [
    ./apps
    ./cli
  ];
  home = {
    stateVersion = "24.05";
    username = "judahf";
    homeDirectory = "/home/judahf";
  };

  programs = {
    ghostty = {
      enable = true;
      settings = {
        background-opacity = 0.8;
        shell-integration-features = [ "ssh-env" "ssh-terminfo" ];
      };
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
