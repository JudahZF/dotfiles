{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    Numbers = 361304891;
  };
}
