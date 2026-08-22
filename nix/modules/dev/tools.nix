{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bootdev-cli
    bruno
    cmake
    gh
    ghidra
    jetbrains.datagrip
    jq
    libpq
    opentofu
    postman
    protobuf
    watchman
    zed-editor

    # Not yet sorted into a category
    gradle
    nixfmt
    phpactor
    swiftformat
  ];
}
