{
  pkgs,
  lib,
  username ? null,
  ...
}:
lib.mkIf (pkgs.stdenv.isDarwin && username != null) {
  # yabai runs from a local fork build (adds `mouse_modifier none`):
  # https://github.com/JudahZF/yabai, branch mouse-modifier-none.
  # Rebuild with: DEVELOPER_DIR=/Library/Developer/CommandLineTools make install
  # then re-grant Accessibility and refresh /etc/sudoers.d/10-yabai-config.
  launchd.user.agents.yabai = {
    serviceConfig = {
      Label = "com.koekeishiya.yabai";
      ProgramArguments = [ "/Users/${username}/Code/personal/yabai/bin/yabai" ];
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "/Users/${username}/Code/personal/yabai/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
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
