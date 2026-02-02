{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.defaults = {
    loginwindow = {
      autoLoginUser = null;
      DisableConsoleAccess = true;
      GuestEnabled = false;
      LoginwindowText = "Property of Judah Fuller";
      PowerOffDisabledWhileLoggedIn = false;
      RestartDisabled = false;
      RestartDisabledWhileLoggedIn = false;
      SHOWFULLNAME = false;
      ShutDownDisabled = true;
      ShutDownDisabledWhileLoggedIn = false;
      SleepDisabled = false;
    };
  };
}
