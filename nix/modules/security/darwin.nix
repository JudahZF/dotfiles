{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "malwarebytes"
    "private-internet-access"
  ];
}
