#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  notify-dotfiles-auto-update.sh --state-dir DIR --kind KIND --title TITLE --message MESSAGE
  notify-dotfiles-auto-update.sh --state-dir DIR --flush
EOF
  exit 2
}

state_dir=
kind=
title=
message=
flush=false

while (($#)); do
  case "$1" in
    --state-dir) state_dir=${2:?}; shift 2 ;;
    --kind) kind=${2:?}; shift 2 ;;
    --title) title=${2:?}; shift 2 ;;
    --message) message=${2:?}; shift 2 ;;
    --flush) flush=true; shift ;;
    *) usage ;;
  esac
done

[[ -n "$state_dir" ]] || usage
mkdir -p "$state_dir"
pending="$state_dir/pending-notification.json"
last_notification="$state_dir/last-delivered-notification.json"
last_notification_at="$state_dir/last-delivered-notification-at"

show_notification() {
  local notification_title=$1 notification_message=$2

  case "$(uname -s)" in
    Darwin)
      /usr/bin/osascript - "$notification_title" "$notification_message" <<'APPLESCRIPT'
on run argv
  display notification (item 2 of argv) with title (item 1 of argv)
end run
APPLESCRIPT
      ;;
    Linux)
      notify-send "$notification_title" "$notification_message"
      ;;
    *) return 1 ;;
  esac
}

write_json_atomically() {
  local destination=$1 payload=$2 temporary
  temporary=$(mktemp "$state_dir/notification.XXXXXX")
  printf '%s\n' "$payload" >"$temporary"
  mv "$temporary" "$destination"
}

if $flush; then
  [[ -f "$pending" ]] || exit 0
  title=$(jq -er .title "$pending")
  message=$(jq -er .message "$pending")
  if show_notification "$title" "$message"; then
    mv "$pending" "$last_notification"
    date +%s >"$last_notification_at"
  fi
  exit 0
fi

[[ -n "$kind" && -n "$title" && -n "$message" ]] || usage

timestamp=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
status_payload=$(jq -n \
  --arg timestamp "$timestamp" \
  --arg kind "$kind" \
  --arg title "$title" \
  --arg message "$message" \
  '{timestamp: $timestamp, kind: $kind, title: $title, message: $message}')
write_json_atomically "$state_dir/last-status.json" "$status_payload"
if [[ "$kind" == failure ]]; then
  write_json_atomically "$state_dir/last-error.json" "$status_payload"
fi

notification_payload=$(jq -n \
  --arg kind "$kind" \
  --arg title "$title" \
  --arg message "$message" \
  '{kind: $kind, title: $title, message: $message}')

if [[ -f "$last_notification" && -f "$last_notification_at" ]] &&
  cmp -s <(printf '%s\n' "$notification_payload") "$last_notification"; then
  delivered_at=$(<"$last_notification_at")
  now=$(date +%s)
  if [[ "$delivered_at" =~ ^[0-9]+$ ]] && ((now - delivered_at < 21600)); then
    exit 0
  fi
fi

if show_notification "$title" "$message"; then
  write_json_atomically "$last_notification" "$notification_payload"
  date +%s >"$last_notification_at"
  rm -f "$pending"
else
  write_json_atomically "$pending" "$notification_payload"
fi
