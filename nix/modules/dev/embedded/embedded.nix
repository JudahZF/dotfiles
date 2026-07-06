{ pkgs, ... }: {
  environment.systemPackages = [
    # adafruit-nrfutil depends on insecure python ecdsa (CVE-2024-23342).
    pkgs.nanopb
    pkgs.platformio
  ];
}
