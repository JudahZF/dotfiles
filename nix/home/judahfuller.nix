{ dotfiles, pkgs, ... }: {
  imports = [ ./cli ./desktop ];
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
    git = {
      enable = true;
      difftastic = {
        options.color = "always";
        enableAsDifftool = true;
        enable = true;
      };
      extraConfig = if pkgs.stdenv.isDarwin then {
        gpg."ssh".program =
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      } else
        { };
      lfs = { enable = true; };
      ignores = [ ".env" ];
      signing = {
        format = "ssh";
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg+m/SsrTx6+3t00tabRdDLms4jYrxGwlh8gG7ZkIsO";
        signByDefault = true;
      };
      userEmail = "judah@judahfuller.com";
      userName = "Judah Fuller";
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
