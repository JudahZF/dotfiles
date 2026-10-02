#!/usr/bin/env bash
set -euo pipefail

# The official installer bakes in the stable version and a SHA256 per platform;
# copy them into packages/origin.nix.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PACKAGE="$SCRIPT_DIR/packages/origin.nix"
INSTALLER="https://downloads.cursor.com/origin/install.sh"
curl_args=(--connect-timeout 15 --max-time 60 --retry 3 --retry-all-errors --fail --silent --show-error)

stable=$(curl "${curl_args[@]}" "$INSTALLER" | awk '/^stable\)/,/^esac/')
version=$(sed -n 's/^  version="\([^"]*\)"$/\1/p' <<<"$stable")
current=$(sed -n 's/^  version = "\([^"]*\)";/\1/p' "$PACKAGE")
[[ -n "$version" ]] || { echo "Could not read the stable Origin version from $INSTALLER" >&2; exit 1; }

if [[ "$version" == "$current" ]]; then
  echo "Origin CLI is current: $version"
  exit 0
fi

sri() {
  local hex
  hex=$(awk -v platform="  $1)" '$0 == platform { found = 1 } found && /sha="/ { split($0, a, "\""); print a[2]; exit }' <<<"$stable")
  [[ ${#hex} -eq 64 ]] || { echo "Missing $1 hash in $INSTALLER" >&2; exit 1; }
  nix hash convert --hash-algo sha256 --to sri "$hex"
}

darwin_arm64=$(sri darwin-arm64)
darwin_x64=$(sri darwin-x64)
linux_arm64=$(sri linux-arm64)
linux_x64=$(sri linux-x64)
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

awk \
  -v version="$version" \
  -v darwin_arm64="$darwin_arm64" \
  -v darwin_x64="$darwin_x64" \
  -v linux_arm64="$linux_arm64" \
  -v linux_x64="$linux_x64" \
  '
    /^  version = "/ { sub(/"[^"]+"/, "\"" version "\"") }
    /platform = "/ { split($0, a, "\""); platform = a[2] }
    /"sha256-/ {
      replacement = platform == "darwin-arm64" ? darwin_arm64 : platform == "darwin-x64" ? darwin_x64 : platform == "linux-arm64" ? linux_arm64 : platform == "linux-x64" ? linux_x64 : ""
      if (replacement == "") exit 1
      sub(/sha256-[^"]+/, replacement)
      hashes++
    }
    { print }
    END { if (hashes != 4) exit 1 }
  ' "$PACKAGE" >"$tmp"

cp "$tmp" "$PACKAGE"
echo "Updated Origin CLI: $current -> $version"
