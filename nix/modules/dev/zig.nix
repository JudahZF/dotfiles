{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zig
    cargo-zigbuild
  ];
}
