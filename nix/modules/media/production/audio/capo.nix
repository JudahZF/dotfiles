{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.masApps = {
    "Capo" = 696977615;
  };
}
