#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FLAKE_REF="$SCRIPT_DIR"

# Detect OS and run appropriate rebuild command
OS=$(uname -s)
old_system=$(readlink -f /run/current-system 2>/dev/null || true)

show_rebuild_diff() {
  local new_system
  new_system=$(readlink -f /run/current-system 2>/dev/null || true)

  if command -v nvd >/dev/null 2>&1 && [[ -n "$old_system" && -n "$new_system" && "$old_system" != "$new_system" ]]; then
    nvd diff "$old_system" "$new_system" || true
  fi
}

if [[ "$OS" == "Darwin" ]]; then
  legacy_skhd_plist="$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
  if [[ -f "$legacy_skhd_plist" ]]; then
    echo "Removing legacy com.koekeishiya.skhd launch agent..."
    launchctl bootout "gui/$(id -u)/com.koekeishiya.skhd" >/dev/null 2>&1 || true
    rm -f "$legacy_skhd_plist"
  fi

  # macOS
  sudo -H darwin-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
  show_rebuild_diff
elif [[ "$OS" == "Linux" ]]; then
  # Linux
  sudo -H nixos-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
  show_rebuild_diff
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
