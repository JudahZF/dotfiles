{ pkgs, lib, ... }:
lib.mkMerge [
  {
    environment.systemPackages = [ pkgs.zsh ];
  }
  (lib.mkIf pkgs.stdenv.isLinux {
    programs.zsh.enable = true;
  })
]
