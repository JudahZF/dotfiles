{ pkgs, lib, ... }: {
  environment.systemPackages = [ pkgs.zsh ];
} // lib.optionalAttrs pkgs.stdenv.isLinux {
  programs.zsh.enable = true;
}
