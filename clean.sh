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

log_info "Starting cleanup process..."

# Run internal cleanup script
if sudo bash "$SCRIPT_DIR/nix/_internal_clean.sh"; then
  log_info "Internal cleanup completed successfully."
else
  log_error "Internal cleanup failed."
  exit 1
fi

log_info "Cleanup process completed successfully."

exit 0
