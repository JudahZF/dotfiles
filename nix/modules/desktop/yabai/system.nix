{ pkgs, lib, username ? null, ... }:
lib.mkIf (pkgs.stdenv.isDarwin && username != null) {
  homebrew = {
    brews = [
      {
        name = "yabai";
        args = [ "--HEAD" ];
      }
    ];
    taps = [ "koekeishiya/formulae" ];
  };

  launchd.user.agents.yabai = {
    serviceConfig = {
      Label = "com.koekeishiya.yabai";
      ProgramArguments = [ "/opt/homebrew/bin/yabai" ];
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      StandardOutPath = "/tmp/yabai_${username}.out.log";
      StandardErrorPath = "/tmp/yabai_${username}.err.log";
      ProcessType = "Interactive";
      Nice = -20;
    };
  };
}
