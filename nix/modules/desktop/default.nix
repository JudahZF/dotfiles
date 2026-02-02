{ pkgs, lib, ... }: {
  imports = lib.optionals pkgs.stdenv.isLinux [
    ./gnome.nix
    ./grim.nix
    ./hyprland.nix
    ./login.nix
  ];
}
