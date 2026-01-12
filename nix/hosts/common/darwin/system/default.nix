{ inputs, ... }: {
  imports = [
    ./activation.nix
    ./defaults.nix
    ./dock.nix
    ./finder.nix
    ./homebrew.nix
    ./keyboard.nix
    ./login.nix
    ./mouse.nix
    ./screen_capture.nix
    ./security.nix
    ./updates.nix
    ./user.nix
    ./window_manager.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.nix-index
  ];
}
