{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "arturia-software-center"
    "native-access"
    "waves-central"
  ];
}
