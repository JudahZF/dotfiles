{ pkgs, lib, ... }:
# Discord not available on aarch64-linux
lib.mkIf (pkgs.stdenv.isDarwin || pkgs.stdenv.hostPlatform.isx86_64) {
  environment.systemPackages = with pkgs; [ discord ];
}
