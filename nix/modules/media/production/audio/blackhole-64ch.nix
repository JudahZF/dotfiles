{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [ "blackhole-64ch" ];
}
