{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  system.activationScripts.cleanupLegacyKoekeishiyaSkhd.text = ''
    if [ -x /opt/homebrew/bin/brew ] && /opt/homebrew/bin/brew list --formula | grep -qx "skhd"; then
      echo "removing legacy koekeishiya skhd formula to prevent skhd-zig link conflicts..." >&2
      /opt/homebrew/bin/brew unlink skhd >/dev/null 2>&1 || true
      /opt/homebrew/bin/brew uninstall --formula skhd >/dev/null 2>&1 || true
    fi
  '';

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
