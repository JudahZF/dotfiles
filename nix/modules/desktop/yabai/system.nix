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
  # then re-grant Accessibility and rebuild to refresh the sudo rule.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    (
      set -eu
      yabai_bin=${lib.escapeShellArg "/Users/${username}/Code/personal/yabai/bin/yabai"}
      if [ ! -x "$yabai_bin" ]; then
        echo "Warning: local yabai binary not found; sudo rule was not updated." >&2
        exit 0
      fi
      yabai_hash=$(/usr/bin/shasum -a 256 "$yabai_bin" | /usr/bin/awk '{ print $1 }')
      sudoers_file=$(/usr/bin/mktemp /etc/sudoers.d/.yabai.XXXXXX)
      trap '/bin/rm "$sudoers_file"' EXIT
      printf '%s ALL=(root) NOPASSWD: NOSETENV: sha256:%s %s --load-sa\n' \
        ${lib.escapeShellArg username} "$yabai_hash" "$yabai_bin" > "$sudoers_file"
      /usr/sbin/visudo -cf "$sudoers_file"
      /usr/bin/install -o root -g wheel -m 0440 "$sudoers_file" /etc/sudoers.d/10-yabai-config
    )
  '';

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
