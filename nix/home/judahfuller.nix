{ dotfiles, pkgs, ... }: {
  imports = [ ./cli ];
  home = {
    stateVersion = "24.05";
    username = "judahfuller";
    homeDirectory = "/Users/judahfuller";
    enableNixpkgsReleaseCheck = false;

    file = pkgs.lib.mkMerge [{
      nix = {
        recursive = true;
        source = "${dotfiles}/nix";
        target = ".config/nix";
      };
      opencode = {
        recursive = true;
        source = "${dotfiles}/opencode";
        target = ".config/opencode";
      };
      # sketchybar = {
      #   recursive = true;
      #   source = "${dotfiles}/sketchybar";
      #   target = ".config/sketchybar";
      # };
      skhd = {
        source = "${dotfiles}/skhdrc";
        target = ".config/skhd/skhdrc";
      };
      yabai = {
        source = "${dotfiles}/yabairc";
        target = ".config/yabai/yabairc";
      };
    }];
  };

  programs = {
    ghostty = {
      enable = true;
      package = null; # Installed via Homebrew
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
