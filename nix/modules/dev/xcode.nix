{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.brews = [ "cocoapods" ];
  homebrew.masApps = {
    "Xcode" = 497799835;
  };
}
