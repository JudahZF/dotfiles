{ ... }:
{
  imports = [
    ./exports.nix
    ./systems.nix
    ./checks.nix
    ./images.nix
    ./colmena.nix
    ./desktop-packages.nix
    ./packages.nix
    ./formatter.nix
  ];
}
