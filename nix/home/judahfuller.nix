{ dotfiles, pkgs, ... }: {
  imports = [ ./cli ];
  home = {
    stateVersion = "24.05";

    file = pkgs.lib.mkMerge [{
      nix = {
        recursive = true;
        source = "${dotfiles}/nix";
        target = ".config/nix";
      };
      sketchybar = {
        recursive = true;
        source = "${dotfiles}/sketchybar";
        target = ".config/sketchybar";
      };
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
