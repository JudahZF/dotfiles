{ system, lib, inputs, ... }: {
  imports = lib.optionals (lib.hasSuffix "-darwin" system) [
    ./activation.nix
    ./defaults.nix
    ./dock.nix
    ./finder.nix
    ./homebrew.nix
    ./keyboard.nix
    ./login.nix
    ./mouse.nix
    ./packages.nix
    ./screen_capture.nix
    ./security.nix
    ./updates.nix
    ./user.nix
    ./window_manager.nix
    ./apps/aldente.nix
    ./apps/music.nix
    ./apps/safari.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
  ];
}
