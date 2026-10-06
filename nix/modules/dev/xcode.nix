{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.brews = [ "cocoapods" ];

  programs.xcodes = {
    enable = true;
    # Nixpkgs still ships 1.6.2, whose Apple ID login receives HTML instead of JSON.
    package = pkgs.callPackage ../../packages/xcodes.nix { };
    versions = [ "27.2 Beta 2" ];
    selectVersion = "27.2 Beta 2";
    # `xcodes installed` can include build metadata in beta version strings
    # (for example `27.0 Beta (27A5194q)`), which currently makes the
    # nix-xcodes prune step misclassify this managed beta as unmanaged and
    # uninstall it immediately after installation.
    pruneUnmanaged = false;
    acceptLicense = true;
  };
}
