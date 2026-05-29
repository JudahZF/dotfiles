#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Optimize Nix Store
# @raycast.mode fullOutput
# @raycast.icon ⚡
# @raycast.packageName Dotfiles
# @raycast.description Optimize nix store

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just optimize
