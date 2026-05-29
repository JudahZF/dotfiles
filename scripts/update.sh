#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Update
# @raycast.mode fullOutput
# @raycast.icon ⬆️
# @raycast.packageName Dotfiles
# @raycast.description Update flake inputs
# @raycast.needsConfirmation true

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just update
