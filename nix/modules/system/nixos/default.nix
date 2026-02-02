{ pkgs, lib, ... }: {
  imports = lib.optionals pkgs.stdenv.isLinux [
    ./audio.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./docker.nix
    ./kernel.nix
    ./localisation.nix
    ./network.nix
    ./packages.nix
    ./ssh.nix
    ./tailscale.nix
  ];
}
