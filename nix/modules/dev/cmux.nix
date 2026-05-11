{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  environment.systemPackages = [
    (import ../../packages/cmux.nix { inherit pkgs lib; })
  ];
}
