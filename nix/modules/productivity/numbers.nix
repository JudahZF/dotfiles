{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    Numbers = 409203825;
  };
}
