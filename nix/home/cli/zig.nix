{ pkgs, ... }: {
  home.packages = with pkgs; [
    zig
    cargo-zigbuild
  ];
}
