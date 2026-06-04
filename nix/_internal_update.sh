#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)
FLAKE_DIR=${SCRIPT_DIR#"$REPO_ROOT"/}
FLAKE_REF="git+file://$REPO_ROOT?dir=$FLAKE_DIR&submodules=1"

nix flake update --flake "$FLAKE_REF"
