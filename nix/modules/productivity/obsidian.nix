{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    (pkgs.obsidian.overrideAttrs (
      old:
      lib.optionalAttrs pkgs.stdenv.isDarwin {
        # Obsidian 1.13.4's DMG gained a versioned wrapper directory, while the
        # nixpkgs package still expects Obsidian.app at the archive root.
        sourceRoot = "Obsidian ${old.version}-universal";
      }
    ))
  ];
}
