{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.masApps = {
    "Final Cut Pro" = 424389933;
  };
}
