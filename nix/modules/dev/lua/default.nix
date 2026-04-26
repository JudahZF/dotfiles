{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lua5_1
    luarocks-nix
  ];
}
