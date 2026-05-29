#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Garbage Collect
# @raycast.mode fullOutput
# @raycast.icon 🗑️
# @raycast.packageName Dotfiles
# @raycast.description Garbage collect old generations
# @raycast.needsConfirmation true
# @raycast.argument1 { "type": "text", "placeholder": "days (default: 7)", "optional": true }

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just gc "${1:-7}"
