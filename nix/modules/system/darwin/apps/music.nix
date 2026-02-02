{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.defaults.CustomUserPreferences = {
    "com.apple.Music" = {
      losslessEnabled = true;
      optimizeSongVolume = false;
      preferredStreamPlaybackAudioQuality = 20;
    };
  };
}
