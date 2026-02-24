#!/bin/sh

# Detect OS and run appropriate rebuild command
OS=$(uname -s)

if [[ "$OS" == "Darwin" ]]; then
  # Remove legacy koekeishiya/skhd artifacts that conflict with skhd-zig linking.
  if command -v brew >/dev/null 2>&1 && brew list --formula 2>/dev/null | grep -qx "skhd"; then
    echo "Removing legacy koekeishiya skhd formula to avoid skhd-zig link conflicts..."
    brew unlink skhd >/dev/null 2>&1 || true
    brew uninstall --formula skhd >/dev/null 2>&1 || true
  fi

  legacy_skhd_plist="$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
  if [[ -f "$legacy_skhd_plist" ]]; then
    echo "Removing legacy com.koekeishiya.skhd launch agent..."
    launchctl bootout "gui/$(id -u)/com.koekeishiya.skhd" >/dev/null 2>&1 || true
    rm -f "$legacy_skhd_plist"
  fi

  # macOS
  sudo -H darwin-rebuild switch --flake ~/dotfiles/nix --max-jobs auto --cores 0
elif [[ "$OS" == "Linux" ]]; then
  # Linux
  sudo -H nixos-rebuild switch --flake ~/dotfiles/nix --max-jobs auto --cores 0
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
