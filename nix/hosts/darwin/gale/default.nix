{ inputs, pkgs, pkgs-unstable, ... }: {
  imports = [
    ./custom-dock.nix
    (import ../../common/all/dev-packages.nix {
      inherit inputs pkgs pkgs-unstable;
    })
    ../../common
    ../../common/all/uni-packages.nix
    ../../common/all/apps/discord.nix
    ../../common/darwin/packages/design.nix
    ../../common/darwin/packages/gaming.nix
    ../../common/darwin/packages/music.nix
    ../../common/darwin/packages/production.nix
  ];
}
