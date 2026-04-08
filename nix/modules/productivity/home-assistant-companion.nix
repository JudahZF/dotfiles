{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    "Home Assistant Companion" = 1099568401;
  };
}
