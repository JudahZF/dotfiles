{
  pkgs,
  lib,
  dotfiles ? null,
  ...
}:
lib.mkIf (pkgs.stdenv.isDarwin && dotfiles != null) {
  home.file.".yabairc" = {
    source = "${dotfiles}/config/yabairc";
    executable = true;
  };

  # CLI for the local yabai fork build (see desktop/yabai/system.nix).
  home.sessionPath = [ "$HOME/Code/personal/yabai/bin" ];
}
