{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew.casks = [
    "helium-browser"
    "zen"
  ];

  system.activationScripts.homebrew.text = lib.mkAfter ''
    if [ -d /Applications/Zen.app ]; then
      # Finder metadata can prevent 1Password from verifying the signed browser.
      echo "repairing Zen browser metadata..." >&2
      /usr/bin/xattr -dr com.apple.FinderInfo /Applications/Zen.app
      if ! /usr/bin/codesign --verify --deep --strict /Applications/Zen.app; then
        echo "error: Zen signature verification failed; 1Password integration may not work." >&2
        exit 1
      fi
    fi
  '';

  system.defaults.CustomUserPreferences."com.apple.Safari" = {
    UniversalSearchEnabled = false;
    SuppressSearchSuggestions = true;
  };
}
