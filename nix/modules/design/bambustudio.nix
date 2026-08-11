{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin { homebrew.casks = [ "bambu-studio" ]; }
