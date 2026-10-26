#!/usr/bin/env bash
set -euo pipefail

die() { printf 'orca-review: %s\n' "$*" >&2; exit 1; }

mode=${1:-auto}
case "$mode" in
  auto|uncommitted|committed|picker) ;;
  *) die 'Usage: orca-review [auto|uncommitted|committed|picker]' ;;
esac
[[ $# -le 1 ]] || die 'Expected at most one review mode.'
port=7391
[[ -z $(ss -H -ltn "sport = :$port") ]] || die "Port $port is already in use."

root=$(git rev-parse --show-toplevel)
cd "$root"
worktree=$(orca worktree show --worktree "path:$root" --json)
worktree_id=$(jq -er 'select(.ok) | .result.worktree.id' <<< "$worktree")

route=/
args=(--port "$port" --no-open)
if [[ $mode == uncommitted ]] || { [[ $mode == auto ]] && [[ -n $(git status --porcelain=v1 --untracked-files=normal) ]]; }; then
  route=/worktree
  args+=(--worktree)
elif [[ $mode != picker ]]; then
  base=$(jq -r '.result.worktree.baseRef // empty' <<< "$worktree")
  if [[ -z $base ]]; then
    repo_id=$(jq -er '.result.worktree.repoId' <<< "$worktree")
    repo=$(orca repo show --repo "id:$repo_id" --json)
    base=$(jq -er 'select(.ok) | .result.repo | .worktreeBaseRef // ""' <<< "$repo")
  fi
  [[ -n $base ]] || die 'No review base found. Configure an Orca base or use picker.'
  base_sha=$(git rev-parse --verify --end-of-options "${base}^{commit}")
  merge_base=$(git merge-base "$base_sha" HEAD)
  if git diff --quiet "$merge_base" HEAD --; then
    [[ $mode != committed ]] || die "No committed changes against $base."
  else
    status=$?
    [[ $status == 1 ]] || die 'Cannot compare committed changes.'
    target="${base}...HEAD"
    route="/compare/$(jq -rn --arg target "$target" '$target | @uri')"
    args+=("$target")
  fi
fi

# Keep upstream attached to this terminal, including its native trust-code prompt.
node "@pullsReview@" "${args[@]}" &
server_pid=$!
cleanup() {
  kill "$server_pid" 2>/dev/null || true
  wait "$server_pid" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

url="http://localhost:$port$route"
# Upstream's ref-route fallback requires HTML Accept; curl's */* returns 404 for ...HEAD.
for ((attempt = 0; attempt < 100; attempt++)); do
  kill -0 "$server_pid" 2>/dev/null || die 'Server exited before startup completed.'
  if curl --noproxy '*' --fail --silent --header 'Accept: text/html' --output /dev/null --max-time 1 "$url"; then break; fi
  sleep 0.1
done
((attempt < 100)) || die 'Timed out waiting for the review server.'

tab=$(orca tab create --worktree "id:$worktree_id" --url "$url" --json)
page=$(jq -er 'select(.ok) | .result.browserPageId' <<< "$tab")
orca tab switch --worktree "id:$worktree_id" --page "$page" --focus --json >/dev/null
wait "$server_pid"
