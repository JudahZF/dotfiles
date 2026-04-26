{
  pkgs,
  lib,
  dotfiles ? null,
  ...
}:
lib.mkIf (pkgs.stdenv.isDarwin && dotfiles != null) {
  home.file.".yabairc" = {
    source = "${dotfiles}/yabairc";
    executable = true;
  };
}
