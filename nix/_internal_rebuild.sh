#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FLAKE_REF="$SCRIPT_DIR"
unattended=false
lock_held=false

while (($#)); do
  case "$1" in
    --unattended)
      unattended=true
      shift
      ;;
    --flake-ref)
      FLAKE_REF=${2:?}
      shift 2
      ;;
    --lock-held)
      lock_held=true
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

OS=$(uname -s)
case "$OS" in
  Darwin)
    state_dir="$HOME/Library/Application Support/dotfiles-auto-update"
    ;;
  Linux)
    state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-auto-update"
    ;;
  *)
    echo "Unsupported operating system: $OS" >&2
    exit 1
    ;;
esac

if ! $lock_held; then
  mkdir -p "$state_dir"
  exec 9>"$state_dir/rebuild.lock"
  if ! flock -n 9; then
    echo "Another dotfiles update or rebuild is already running." >&2
    exit 1
  fi
fi

old_system=$(readlink -f /run/current-system 2>/dev/null || true)

show_rebuild_diff() {
  local new_system
  new_system=$(readlink -f /run/current-system 2>/dev/null || true)

  if command -v nvd >/dev/null 2>&1 && [[ -n "$old_system" && -n "$new_system" && "$old_system" != "$new_system" ]]; then
    nvd diff "$old_system" "$new_system" || true
  fi
}

if [[ "$OS" == Darwin ]]; then
  domain="gui/$(id -u)"

  legacy_skhd_plist="$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
  if [[ -f "$legacy_skhd_plist" ]]; then
    echo "Removing legacy com.koekeishiya.skhd launch agent..."
    launchctl bootout "$domain/com.koekeishiya.skhd" >/dev/null 2>&1 || true
    rm -f "$legacy_skhd_plist"
  fi

  # yabai --install-service writes com.asmvik.yabai; nix-darwin manages
  # com.koekeishiya.yabai. Remove the legacy agent so only one runs at login.
  legacy_yabai_plist="$HOME/Library/LaunchAgents/com.asmvik.yabai.plist"
  if [[ -f "$legacy_yabai_plist" ]]; then
    echo "Removing legacy com.asmvik.yabai launch agent..."
    launchctl bootout "$domain/com.asmvik.yabai" >/dev/null 2>&1 || true
    rm -f "$legacy_yabai_plist"
  fi

  if $unattended; then
    /usr/bin/sudo -n -H /run/current-system/sw/bin/darwin-rebuild \
      switch --flake "$FLAKE_REF" --max-jobs 1 --cores 1
  else
    /usr/bin/sudo -H /run/current-system/sw/bin/darwin-rebuild \
      switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
  fi
  show_rebuild_diff
elif [[ "$OS" == Linux ]]; then
  if $unattended; then
    /run/wrappers/bin/sudo -n -H /run/current-system/sw/bin/nixos-rebuild \
      switch --flake "$FLAKE_REF" --max-jobs 1 --cores 1
  else
    sudo -H nixos-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
  fi
  show_rebuild_diff
fi
