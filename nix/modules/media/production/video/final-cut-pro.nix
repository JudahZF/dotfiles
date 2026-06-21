{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    "Final Cut Pro" = 424389933;
  };
}
