{ ... }:
{
  imports = [
    ./custom-dock.nix
    ../../common/design-packages.nix
    ../../common/dev-packages.nix
    ../../common/dev-packages-config.nix
    ../../common/gaming-packages.nix
    ../../common/darwin/design-packages.nix
    ../../common/darwin/gaming-packages.nix
    ../../common/darwin/music-packages.nix
    ../../common/darwin/production-packages.nix
  ];
}
