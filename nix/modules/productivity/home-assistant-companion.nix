{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.masApps = {
    "Home Assistant Companion" = 1099568401;
  };
}
