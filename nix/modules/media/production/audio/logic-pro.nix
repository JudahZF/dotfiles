{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.masApps = {
    "Logic Pro" = 634148309;
  };
}
