#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FLAKE_REF="$SCRIPT_DIR"

# Detect OS and run appropriate rebuild command
OS=$(uname -s)

if [[ "$OS" == "Darwin" ]]; then
  # Remove legacy skhd formula artifacts that conflict with the skhd-zig cask linking.
  if command -v brew >/dev/null 2>&1; then
    for formula in skhd skhd-zig; do
      if brew list --formula 2>/dev/null | grep -qx "$formula"; then
        echo "Removing legacy $formula formula to avoid skhd-zig cask link conflicts..."
        brew unlink "$formula" >/dev/null 2>&1 || true
        brew uninstall --formula "$formula" >/dev/null 2>&1 || true
      fi
    done
  fi

  legacy_skhd_plist="$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
  if [[ -f "$legacy_skhd_plist" ]]; then
    echo "Removing legacy com.koekeishiya.skhd launch agent..."
    launchctl bootout "gui/$(id -u)/com.koekeishiya.skhd" >/dev/null 2>&1 || true
    rm -f "$legacy_skhd_plist"
  fi

  # macOS
  sudo -H darwin-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
elif [[ "$OS" == "Linux" ]]; then
  # Linux
  sudo -H nixos-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
