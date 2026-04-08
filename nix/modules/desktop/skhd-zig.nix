{ pkgs, lib, options, username ? null, dotfiles ? null, ... }:
lib.mkMerge [
  (lib.mkIf (pkgs.stdenv.isDarwin && options ? homebrew.brews) {
    homebrew = {
      brews = [ "jackielii/tap/skhd-zig" ];
      taps = [ "jackielii/tap" ];
    };
  })
  (lib.mkIf (pkgs.stdenv.isDarwin && username != null && options ? system.activationScripts) {
    system.activationScripts = {
      cleanupLegacyKoekeishiyaSkhd.text = ''
        if [ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew list --formula | grep -qx "skhd"; then
          echo "removing legacy koekeishiya skhd formula to prevent skhd-zig link conflicts..." >&2
          /opt/homebrew/bin/brew unlink skhd >/dev/null 2>&1 || true
          /opt/homebrew/bin/brew uninstall --formula skhd >/dev/null 2>&1 || true
        fi
      '';

      cleanupLegacySkhd.text = ''
        legacy_skhd_plist="/Users/${username}/Library/LaunchAgents/com.koekeishiya.skhd.plist"
        if [ -f "$legacy_skhd_plist" ]; then
          echo "removing legacy koekeishiya skhd launch agent..." >&2
          uid="$(id -u ${username})"
          /bin/launchctl bootout "gui/$uid/com.koekeishiya.skhd" >/dev/null 2>&1 || true
          rm -f "$legacy_skhd_plist"
        fi
      '';
    };
  })
  (lib.mkIf (pkgs.stdenv.isDarwin && username != null && options ? launchd.user.agents) {
    launchd.user.agents.skhd = {
      serviceConfig = {
        Label = "com.jackielii.skhd";
        ProgramArguments =
          [ "/opt/homebrew/opt/skhd-zig/bin/skhd" "-c" "/Users/${username}/.skhdrc" ];
        EnvironmentVariables = {
          HOME = "/Users/${username}";
          PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        RunAtLoad = true;
        KeepAlive = {
          SuccessfulExit = false;
          Crashed = true;
        };
        StandardOutPath = "/tmp/skhd_${username}.out.log";
        StandardErrorPath = "/tmp/skhd_${username}.err.log";
        ProcessType = "Interactive";
        Nice = -20;
      };
    };
  })
  (lib.mkIf (pkgs.stdenv.isDarwin && dotfiles != null && options ? home.file) {
    home.file.".skhdrc".source = "${dotfiles}/skhdrc";
  })
]
