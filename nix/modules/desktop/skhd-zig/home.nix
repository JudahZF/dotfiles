{ pkgs, lib, dotfiles ? null, ... }:
lib.mkIf (pkgs.stdenv.isDarwin && dotfiles != null) {
  home.file.".skhdrc".source = "${dotfiles}/skhdrc";
}
