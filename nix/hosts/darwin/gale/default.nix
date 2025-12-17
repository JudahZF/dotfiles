{ inputs, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./custom-dock.nix
    (import ../../common/all/dev-packages.nix { inherit inputs pkgs pkgs-unstable; })
    ../../common
    ../../common/darwin/packages/design.nix
    ../../common/darwin/packages/gaming.nix
    ../../common/darwin/packages/music.nix
    ../../common/darwin/packages/production.nix
  ];
}
