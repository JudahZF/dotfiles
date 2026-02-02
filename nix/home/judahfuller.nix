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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
      };

      shellAliases = {
        # Git
        g = "git";
        ga = "git add";
        gc = "git commit";
        gd = "git diff";
        gs = "git status";
        gp = "git push";

        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";

        # Nix
        rebuild = "~/dotfiles/rebuild.sh";
        update = "~/dotfiles/update.sh";

        # Modern tools
        cat = "bat --paging=never";
        ls = "eza --icons";
        ll = "eza -la --icons";
        lt = "eza --tree --level=2 --icons";
      };

      initContent = if pkgs.stdenv.isDarwin then
        builtins.readFile "${dotfiles}/zsh/macos/zshrc"
      else
        builtins.readFile "${dotfiles}/zsh/linux/zshrc";
    };
  };
}
