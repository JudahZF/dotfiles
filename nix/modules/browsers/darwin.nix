{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "helium-browser"
    "zen"
  ];

  system.defaults.CustomUserPreferences."com.apple.Safari" = {
    UniversalSearchEnabled = false;
    SuppressSearchSuggestions = true;
  };
}
