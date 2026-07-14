#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
FLAKE_REF="$SCRIPT_DIR"

if token=${GITHUB_TOKEN:-${GH_TOKEN:-}}; [[ -z "$token" ]] && command -v gh >/dev/null; then
  token=$(gh auth token --hostname github.com 2>/dev/null || true)
fi

if [[ -n "$token" ]]; then
  export NIX_CONFIG="${NIX_CONFIG:+$NIX_CONFIG$'\n'}extra-access-tokens = github.com=$token"
fi

nix flake update --flake "$FLAKE_REF"
