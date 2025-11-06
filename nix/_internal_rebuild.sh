#!/bin/sh

# Detect OS and run appropriate rebuild command
OS=$(uname -s)

if [[ "$OS" == "Darwin" ]]; then
  # macOS
  sudo --preserve-env=HOME darwin-rebuild switch --flake ~/dotfiles/nix --show-trace --max-jobs auto --cores 0
elif [[ "$OS" == "Linux" ]]; then
  # Linux
  sudo --preserve-env=HOME nixos-rebuild switch --flake ~/dotfiles/nix --show-trace --max-jobs auto --cores 0
else
  echo "Unsupported operating system: $OS"
  exit 1
fi
