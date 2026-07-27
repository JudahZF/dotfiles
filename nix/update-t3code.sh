#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PACKAGE="$SCRIPT_DIR/packages/t3code.nix"
RELEASES="https://api.github.com/repos/pingdotgg/t3code/releases?per_page=20"

release=$(curl -fsSL "$RELEASES" | jq -er 'first(.[] | select(.prerelease and (.tag_name | contains("-nightly."))))')
version=$(jq -r '.tag_name | ltrimstr("v")' <<<"$release")
current=$(sed -n 's/^  version = "\([^"]*\)";/\1/p' "$PACKAGE")

if [[ "$version" == "$current" ]]; then
  echo "T3 Code is current: $version"
  exit 0
fi

hash() {
  local asset=$1 url
  url=$(jq -er --arg asset "$asset" '.assets[] | select(.name == $asset) | .browser_download_url' <<<"$release")
  nix store prefetch-file --json "$url" | jq -er .hash
}

linux_hash=$(hash "T3-Code-$version-x86_64.AppImage")
arm64_hash=$(hash "T3-Code-$version-arm64.zip")
x64_hash=$(hash "T3-Code-$version-x64.zip")
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

awk \
  -v version="$version" \
  -v linux_hash="$linux_hash" \
  -v arm64_hash="$arm64_hash" \
  -v x64_hash="$x64_hash" \
  '
    /^  version = "/ { sub(/"[^"]+"/, "\"" version "\"") }
    /"sha256-/ {
      hashes++
      replacement = hashes == 1 ? linux_hash : hashes == 2 ? arm64_hash : x64_hash
      sub(/sha256-[^"]+/, replacement)
    }
    { print }
    END { if (hashes != 3) exit 1 }
  ' "$PACKAGE" >"$tmp"

cp "$tmp" "$PACKAGE"
echo "Updated T3 Code: $current -> $version"
