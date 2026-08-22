{ pkgs, lib, ... }:
lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      bash
      zsh
    ];
  }
  (lib.mkIf pkgs.stdenv.isLinux { programs.zsh.enable = true; })
]
