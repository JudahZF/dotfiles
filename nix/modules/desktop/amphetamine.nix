{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.masApps = {
    "Amphetamine" = 937984704;
  };
}
