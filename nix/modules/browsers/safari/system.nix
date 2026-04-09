{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.defaults.CustomUserPreferences = {
    "com.apple.Safari" = {
      UniversalSearchEnabled = false;
      SuppressSearchSuggestions = true;
    };
  };
}
