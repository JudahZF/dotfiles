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
  # Homebrew now refuses to load formulae/casks from third-party taps unless they
  # are explicitly trusted. nix-darwin runs `brew bundle` during activation, so
  # make sure declarative taps used by this flake are trusted before rebuilding.
  if command -v brew >/dev/null 2>&1 && brew help trust >/dev/null 2>&1; then
    for tap in \
      bevanjkay/tap \
      felixkratz/formulae \
      filosottile/musl-cross \
      gcenx/wine \
      jackielii/tap \
      koekeishiya/formulae \
      samtay/tui \
      steipete/tap \
      withgraphite/tap; do
      brew trust "$tap" >/dev/null 2>&1 || true
    done
  fi

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
  show_rebuild_diff
elif [[ "$OS" == "Linux" ]]; then
  # Linux
  sudo -H nixos-rebuild switch --flake "$FLAKE_REF" --max-jobs auto --cores 0
  show_rebuild_diff
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
