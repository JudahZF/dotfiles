{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    adafruit-nrfutil
    bootdev-cli
    nanopb
    platformio
  ];
}
