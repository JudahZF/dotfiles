#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Rebuild
# @raycast.mode fullOutput
# @raycast.icon 🔁
# @raycast.packageName Dotfiles
# @raycast.description Rebuild and switch to new configuration
# @raycast.needsConfirmation true

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just rebuild
