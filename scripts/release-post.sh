#!/usr/bin/env bash
# Generate a Jekyll post for one qrcp GitHub release.
#
# Usage:
#   scripts/release-post.sh <tag>       # one release, e.g. v0.11.7
#   scripts/release-post.sh --all       # backfill every published release
#
# Requires: gh (authenticated, or GH_TOKEN set), jq.
# Writes _posts/YYYY-MM-DD-<tag>.md relative to the repository root.
# Used both for the one-off backfill and by the release workflow in the qrcp repo.
set -euo pipefail

REPO="${QRCP_REPO:-claudiodangelis/qrcp}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POSTS="$ROOT/_posts"
mkdir -p "$POSTS"

write_post() {
  local tag="$1" json date file
  json="$(gh release view "$tag" -R "$REPO" --json tagName,name,publishedAt,url,body,isPrerelease,isDraft)"

  if [[ "$(jq -r .isDraft <<<"$json")" == "true" ]]; then
    echo "skip draft $tag" >&2
    return
  fi

  date="$(jq -r '.publishedAt | sub("T.*"; "")' <<<"$json")"
  file="$POSTS/$date-$tag.md"

  # Remove any older post for the same tag (e.g. re-published on another day).
  find "$POSTS" -name "*-$tag.md" ! -path "$file" -delete

  {
    echo "---"
    echo "layout: release"
    echo "category: releases"
    jq -r '"title: \((.name // "" | if . == "" then .tagName else . end) // .tagName | tojson)"' <<<"$json"
    jq -r '"version: \(.tagName | tojson)"' <<<"$json"
    jq -r '"date: \(.publishedAt)"' <<<"$json"
    jq -r '"release_url: \(.url | tojson)"' <<<"$json"
    jq -r '"prerelease: \(.isPrerelease)"' <<<"$json"
    echo "---"
    echo
    echo "{% raw %}"
    # kramdown needs a blank line before a table (GitHub markdown doesn't).
    jq -r '.body // "" | gsub("\r"; "")' <<<"$json" |
      awk '/^\|/ && prev !~ /^\|/ && prev != "" { print "" } { print; prev = $0 }'
    echo "{% endraw %}"
  } >"$file"

  echo "wrote ${file#"$ROOT"/}"
}

if [[ "${1:-}" == "--all" ]]; then
  gh release list -R "$REPO" -L 1000 --json tagName --jq '.[].tagName' |
    while read -r tag; do write_post "$tag"; done
elif [[ -n "${1:-}" ]]; then
  write_post "$1"
else
  echo "usage: $0 <tag> | --all" >&2
  exit 1
fi
