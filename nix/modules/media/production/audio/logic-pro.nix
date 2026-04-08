{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    "Logic Pro" = 634148309;
  };
}
