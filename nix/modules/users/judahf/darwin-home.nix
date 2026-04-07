{ dotfiles, lib, pkgs, ... }: {
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".skhdrc".source = "${dotfiles}/skhdrc";
    ".yabairc" = {
      source = "${dotfiles}/yabairc";
      executable = true;
    };
  };
}
