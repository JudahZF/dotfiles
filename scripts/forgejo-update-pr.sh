#!/usr/bin/env bash
set -euo pipefail

: "${FORGEJO_SERVER_URL:?FORGEJO_SERVER_URL is required}"
: "${FORGEJO_REPOSITORY:?FORGEJO_REPOSITORY is required}"
: "${DOTFILES_AUTOMATION_TOKEN:?DOTFILES_AUTOMATION_TOKEN is required}"

head_branch=${UPDATE_BRANCH:-automation/update-pins}
base_branch=${TARGET_BRANCH:-main}
title=${UPDATE_PR_TITLE:-Update dependency pins}
body=${UPDATE_PR_BODY:-$'Automated update of Nix flake inputs and the pinned T3 Code nightly.\n\nThis pull request is configured to merge after the required checks succeed.'}
api="${FORGEJO_SERVER_URL%/}/api/v1/repos/$FORGEJO_REPOSITORY"
head_commit=${UPDATE_HEAD_COMMIT:-$(git rev-parse HEAD)}

curl_common=(
  --connect-timeout 15
  --max-time 60
  --retry 3
  --retry-all-errors
  --fail-with-body
  --silent
  --show-error
  -H "Authorization: token $DOTFILES_AUTOMATION_TOKEN"
)
json=(-H "Content-Type: application/json")

pulls=$(curl "${curl_common[@]}" \
  --get \
  --data-urlencode state=open \
  --data-urlencode "base=$base_branch" \
  --data-urlencode "head=$head_branch" \
  --data-urlencode limit=50 \
  "$api/pulls")

pull_number=$(jq -r --arg head "$head_branch" --arg base "$base_branch" \
  'first(.[] | select(.head.ref == $head and .base.ref == $base) | .number) // empty' \
  <<<"$pulls")

pull_payload=$(jq -n \
  --arg title "$title" \
  --arg body "$body" \
  --arg head "$head_branch" \
  --arg base "$base_branch" \
  '{title: $title, body: $body, head: $head, base: $base}')

if [[ -z "$pull_number" ]]; then
  pull=$(curl "${curl_common[@]}" "${json[@]}" \
    --request POST \
    --data "$pull_payload" \
    "$api/pulls")
  pull_number=$(jq -er .number <<<"$pull")
else
  edit_payload=$(jq -n --arg title "$title" --arg body "$body" '{title: $title, body: $body}')
  curl "${curl_common[@]}" "${json[@]}" \
    --request PATCH \
    --data "$edit_payload" \
    "$api/pulls/$pull_number" >/dev/null
fi

merge_payload=$(jq -n \
  --arg head_commit_id "$head_commit" \
  '{
    Do: "squash",
    delete_branch_after_merge: true,
    head_commit_id: $head_commit_id,
    merge_when_checks_succeed: true
  }')

curl "${curl_common[@]}" "${json[@]}" \
  --request POST \
  --data "$merge_payload" \
  "$api/pulls/$pull_number/merge" >/dev/null

printf 'Update pull request: %s/%s/pulls/%s\n' "${FORGEJO_SERVER_URL%/}" "$FORGEJO_REPOSITORY" "$pull_number"
