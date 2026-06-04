{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dmidecode
    lm_sensors
    nvme-cli
    pciutils
    smartmontools
    usbutils
  ];
}
