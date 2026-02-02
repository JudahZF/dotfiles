{ pkgs, lib, ... }: {
  # Hardware modules should be imported explicitly by hosts that need them
  # This avoids issues with NixOS-specific kernel module options on Darwin
}
