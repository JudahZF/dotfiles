{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.casks = [
    "arturia-software-center"
    "ilok-license-manager"
    "native-access"
    "waves-central"
  ];
}
