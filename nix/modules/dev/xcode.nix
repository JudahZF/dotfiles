{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.brews = [ "cocoapods" ];

  programs.xcodes = {
    enable = true;
    versions = [ "27.0 Beta" ];
    selectVersion = "27.0 Beta";
    # `xcodes installed` can include build metadata in beta version strings
    # (for example `27.0 Beta (27A5194q)`), which currently makes the
    # nix-xcodes prune step misclassify this managed beta as unmanaged and
    # uninstall it immediately after installation.
    pruneUnmanaged = false;
    acceptLicense = true;
  };
}
