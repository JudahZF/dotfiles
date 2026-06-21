{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.masApps = {
    "Amphetamine" = 937984704;
  };
}
