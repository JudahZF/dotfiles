#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Clean
# @raycast.mode fullOutput
# @raycast.icon 🧹
# @raycast.packageName Dotfiles
# @raycast.description Clean up old generations (user + system) and optimise
# @raycast.needsConfirmation true
# @raycast.argument1 { "type": "text", "placeholder": "days (default: 7)", "optional": true }

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just clean "${1:-7}"
