{ ... }: {
  system.defaults.CustomUserPreferences = {
    "com.apple.Safari" = {
      # Privacy: don't send search queries to Apple
      UniversalSearchEnabled = false;
      SuppressSearchSuggestions = true;
    };
  };
}
