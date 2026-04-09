{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.adafruit-nrfutil
    pkgs.nanopb
    pkgs.platformio
  ];
}
