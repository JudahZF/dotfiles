{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew = {
    casks = [ "wispr-flow" ];
  };
}
