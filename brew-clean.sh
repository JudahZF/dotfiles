#!/usr/bin/env bash
set -euo pipefail

# Logging functions
log_info() {
  printf '%s [INFO] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"
}

log_error() {
  printf '%s [ERROR] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*" >&2
}

if ! command -v brew >/dev/null 2>&1; then
  log_error "Homebrew (brew) not found on PATH."
  exit 1
fi

log_info "Starting Homebrew cache cleanup..."

cache_dir="$(brew --cache)"
before_bytes="$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')"
before_human="$(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}')"
log_info "Cache before: ${before_human:-unknown} (${cache_dir})"

# Remove old versions, unused deps, and scrub the download cache.
brew autoremove --quiet || true
brew cleanup -s -v

# Wipe the full Homebrew cache (including downloads for installed formulae/casks).
# Safe: only removes cached archives; next brew install/upgrade will re-download.
log_info "Removing Homebrew cache directory: ${cache_dir}"
rm -rf -- "${cache_dir}"

after_bytes=0
after_human="0B"
if [[ -d "$cache_dir" ]]; then
  after_bytes="$(du -sk "$cache_dir" 2>/dev/null | awk '{print $1}')"
  after_human="$(du -sh "$cache_dir" 2>/dev/null | awk '{print $1}')"
fi
log_info "Cache after: ${after_human:-unknown}"

if [[ -n "${before_bytes:-}" ]]; then
  freed_kb=$((before_bytes - ${after_bytes:-0}))
  if ((freed_kb > 0)); then
    log_info "Freed approximately ${freed_kb}K from the Homebrew cache."
  else
    log_info "No significant Homebrew cache space was freed."
  fi
fi

log_info "Homebrew cache cleanup completed successfully."

exit 0
