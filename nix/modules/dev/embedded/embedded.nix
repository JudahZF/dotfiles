{ pkgs, lib, options, ... }:
lib.mkMerge [
  {
    environment.systemPackages = [
      pkgs.adafruit-nrfutil
      pkgs.nanopb
      pkgs.platformio
    ];
  }
  (lib.mkIf (pkgs.stdenv.isDarwin && options ? homebrew.casks) {
    homebrew.casks = [ "silicon-labs-vcp-driver" ];
  })
]
