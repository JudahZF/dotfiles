{ dotfiles, pkgs, ... }: {
  imports = [
    ../../apps
    ../../cli
  ];
  home = {
    stateVersion = "24.05";
    username = if pkgs.stdenv.isDarwin then "judahfuller" else "judahf";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/judahfuller" else "/home/judahf";
    enableNixpkgsReleaseCheck = false;
  };

  programs = {
    ghostty = {
      # Only enable via home-manager on Linux; Darwin uses Homebrew cask
      enable = pkgs.stdenv.isLinux;
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
