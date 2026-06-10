{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  nix-zerobrew.brews = [ "cocoapods" ];

  programs.xcodes = {
    enable = true;
    versions = [ "27 beta" ];
    selectVersion = "27 beta";
    acceptLicense = true;
  };
}
