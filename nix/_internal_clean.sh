#!/usr/bin/env bash
set -euo pipefail

DAYS="${1:-7}"

# User profiles (home-manager, etc.) — must run as the invoking user.
nix-collect-garbage --delete-older-than "${DAYS}d"

# System/root profiles.
sudo nix-collect-garbage --delete-older-than "${DAYS}d"

sudo nix store optimise -v
