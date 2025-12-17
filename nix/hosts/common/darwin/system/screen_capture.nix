{ ... }: {
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.screencapture" = {
        disable-shadow = true;
        show-thumbnail = true;
        type = "png";
      };
    };
    screencapture = {
      disable-shadow = false;
      location = "~/Pictures/Screen Captures/";
      show-thumbnail = true;
      type = "png";
    };
  };
}
