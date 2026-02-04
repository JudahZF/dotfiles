{ system, lib, ... }: {
  imports = lib.optionals (lib.hasSuffix "-linux" system) [
    ./gnome.nix
    ./grim.nix
    ./hyprland.nix
    ./login.nix
  ];
}
