#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Logging functions
log_info() {
  printf '%s [INFO] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

log_error() {
  printf '%s [ERROR] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

log_info "Starting update process..."

# Run internal update script
if bash "$SCRIPT_DIR/nix/_internal_update.sh"; then
  log_info "Internal update completed successfully."
else
  log_error "Internal update failed."
  exit 1
fi

log_info "Update process completed successfully. Please rebuild."

exit 0
