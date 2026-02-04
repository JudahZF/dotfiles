{ system, lib, ... }: {
  imports = lib.optionals (lib.hasSuffix "-linux" system) [
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
