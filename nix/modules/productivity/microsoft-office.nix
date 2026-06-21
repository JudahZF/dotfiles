{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "microsoft-office"
    "microsoft-teams"
  ];
}
