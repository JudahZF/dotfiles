#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Clean
# @raycast.mode fullOutput
# @raycast.icon 🧹
# @raycast.packageName Dotfiles
# @raycast.description Clean up old generations (7+ days)
# @raycast.needsConfirmation true

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just clean
