{ inputs, ... }: { imports = [ inputs.walker.homeManagerModules.default ./hyprland.nix ./walker.nix ./waybar.nix ]; }
