#!/usr/bin/env bash
set -euo pipefail

nix-collect-garbage --delete-older-than 7d
nix store optimise -v
