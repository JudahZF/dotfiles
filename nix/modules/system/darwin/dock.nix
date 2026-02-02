{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.defaults = {
    CustomUserPreferences = {
      "com.apple.dock" = {
        autohide = true;
        autohide-delay = 0;
        autohide-time-modifier = 0;
        appswitcher-all-displays = true;
        enable-window-tool = false;
        expose-animation-duration = 0.1;
        launchanim = false;
        magnification = false;
        minimize-to-application = true;
        mineffect = "scale";
        orientation = "right";
        static-only = false;
        show-recents = false;
        show-process-indicators = true;
        tilesize = 48;
      };
    };
    dock = {
      appswitcher-all-displays = true;
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      dashboard-in-overlay = false;
      enable-spring-load-actions-on-all-items = false;
      expose-animation-duration = 0.1;
      expose-group-apps = false;
      largesize = 16;
      launchanim = false;
      magnification = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = false;
      mru-spaces = false;
      orientation = "right";
      persistent-others = [ ];
      show-process-indicators = true;
      show-recents = false;
      showhidden = false;
      slow-motion-allowed = false;
      static-only = false;
      tilesize = 48;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 12;
    };
  };
}
