#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Clean Homebrew Cache
# @raycast.mode fullOutput
# @raycast.icon 🍺
# @raycast.packageName Dotfiles
# @raycast.description Clean Homebrew cache, including downloads for installed formulae/casks
# @raycast.needsConfirmation true

set -euo pipefail

cd "${DOTFILES_DIR:-$HOME/dotfiles}"
just brew-clean
