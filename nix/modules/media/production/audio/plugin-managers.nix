{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "arturia-software-center"
    "ilok-license-manager"
    "native-access"
    "ua-connect"
    "waves-central"
  ];
}
