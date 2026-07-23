#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: apply-approved-dotfiles.sh \
  --repo PATH --branch BRANCH --remote-url URL --flake-ref REF \
  --state-dir DIR --notify-command PATH --rebuild-command PATH
EOF
  exit 2
}

repo=
branch=
remote_url=
flake_ref=
state_dir=
notify_command=
rebuild_command=

while (($#)); do
  case "$1" in
    --repo) repo=${2:?}; shift 2 ;;
    --branch) branch=${2:?}; shift 2 ;;
    --remote-url) remote_url=${2:?}; shift 2 ;;
    --flake-ref) flake_ref=${2:?}; shift 2 ;;
    --state-dir) state_dir=${2:?}; shift 2 ;;
    --notify-command) notify_command=${2:?}; shift 2 ;;
    --rebuild-command) rebuild_command=${2:?}; shift 2 ;;
    *) usage ;;
  esac
done

for required in repo branch remote_url flake_ref state_dir notify_command rebuild_command; do
  [[ -n ${!required} ]] || usage
done

mkdir -p "$state_dir"
lock_file="$state_dir/rebuild.lock"
exec 9>"$lock_file"

notify() {
  local kind=$1 title=$2 message=$3
  "$notify_command" \
    --state-dir "$state_dir" \
    --kind "$kind" \
    --title "$title" \
    --message "$message" || true
}

fail() {
  local message=$1
  printf 'dotfiles auto-update: %s\n' "$message" >&2
  notify failure "Dotfiles update failed" "$message"
  exit 1
}

"$notify_command" --state-dir "$state_dir" --flush || true
flock -n 9 || fail "Another update or rebuild is already running."

git_cmd=(env GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=20 -o ServerAliveInterval=15 -o ServerAliveCountMax=3" git)
git_repo() {
  "${git_cmd[@]}" -C "$repo" "$@"
}

[[ -d "$repo" ]] || fail "Repository does not exist: $repo"
git_repo rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "Not a Git worktree: $repo"

current_branch=$(git_repo symbolic-ref --quiet --short HEAD 2>/dev/null || true)
[[ "$current_branch" == "$branch" ]] || fail "Expected branch $branch, found ${current_branch:-detached HEAD}."

actual_remote=$(git_repo remote get-url origin 2>/dev/null || true)
[[ "$actual_remote" == "$remote_url" ]] || fail "Unexpected origin URL: ${actual_remote:-missing}."

git_dir=$(git_repo rev-parse --absolute-git-dir)
for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD BISECT_LOG; do
  [[ ! -e "$git_dir/$marker" ]] || fail "Git operation is in progress ($marker)."
done
for rebase_dir in rebase-merge rebase-apply; do
  [[ ! -d "$git_dir/$rebase_dir" ]] || fail "Git rebase is in progress."
done

status=$(git_repo status --porcelain=v1 --untracked-files=normal)
[[ -z "$status" ]] || fail "The dotfiles checkout is dirty; commit, stash, or remove local changes first."

fetch_log=$(mktemp "$state_dir/fetch.XXXXXX")
rebuild_log=$(mktemp "$state_dir/rebuild.XXXXXX")
cleanup_logs() {
  rm -f "$fetch_log" "$rebuild_log"
}
trap cleanup_logs EXIT

if ! timeout --foreground 10m "${git_cmd[@]}" -C "$repo" \
  -c http.lowSpeedLimit=1 -c http.lowSpeedTime=30 \
  fetch --prune origin "+refs/heads/$branch:refs/remotes/origin/$branch" >"$fetch_log" 2>&1; then
  cp "$fetch_log" "$state_dir/last-fetch-error.log"
  fail "Could not fetch origin/$branch; see $state_dir/last-fetch-error.log."
fi

status=$(git_repo status --porcelain=v1 --untracked-files=normal)
[[ -z "$status" ]] || fail "The checkout changed while fetching; it was not advanced or rebuilt."

local_head=$(git_repo rev-parse HEAD)
remote_head=$(git_repo rev-parse "refs/remotes/origin/$branch")
if ! git_repo merge-base --is-ancestor "$local_head" "$remote_head"; then
  fail "Local $branch is ahead of or diverged from origin/$branch; refusing to modify it."
fi

if [[ "$local_head" != "$remote_head" ]]; then
  git_repo merge --ff-only "$remote_head" >/dev/null || fail "Fast-forward merge failed; the checkout was not rebuilt."
fi

current_head=$(git_repo rev-parse HEAD)
status=$(git_repo status --porcelain=v1 --untracked-files=normal)
[[ -z "$status" ]] || fail "The checkout is not clean after fast-forward; refusing to rebuild."

last_success_file="$state_dir/last-successfully-activated-head"
last_success=
if [[ -f "$last_success_file" ]]; then
  last_success=$(<"$last_success_file")
fi
if [[ "$current_head" == "$last_success" ]]; then
  exit 0
fi

if ! timeout --foreground 6h "$rebuild_command" \
  --unattended --flake-ref "$flake_ref" --lock-held >"$rebuild_log" 2>&1; then
  cp "$rebuild_log" "$state_dir/last-rebuild-error.log"
  fail "Rebuild failed for ${current_head:0:12}; see $state_dir/last-rebuild-error.log."
fi

state_tmp=$(mktemp "$state_dir/last-success.XXXXXX")
printf '%s\n' "$current_head" >"$state_tmp"
mv "$state_tmp" "$last_success_file"
notify success "Dotfiles updated" "Activated ${current_head:0:12} on $(hostname -s)."

if [[ $(uname -s) == Linux ]]; then
  booted_kernel=$(readlink -f /run/booted-system/kernel 2>/dev/null || true)
  current_kernel=$(readlink -f /run/current-system/kernel 2>/dev/null || true)
  if [[ -n "$booted_kernel" && -n "$current_kernel" && "$booted_kernel" != "$current_kernel" ]]; then
    notify success "NixOS updates installed" "Reboot recommended on $(hostname -s)."
  fi
fi
