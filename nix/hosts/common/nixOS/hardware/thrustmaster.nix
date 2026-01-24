# Thrustmaster racing wheel support with force feedback
# Supports T300RS, T248, T128, TX, TS-XW, TS-PC and similar wheels
{ config, ... }: {
  # Load hid-tmff2 kernel module for Thrustmaster force feedback
  boot.extraModulePackages = [ config.boot.kernelPackages.hid-tmff2 ];

  # Udev rules for Thrustmaster wheels (Vendor ID 044f)
  # Grants input group access for non-root usage
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="044f", MODE="0660", GROUP="input"
  '';
}
