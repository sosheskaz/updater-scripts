#!/bin/bash

set -e
set -o pipefail

repo="$(dirname "$0")"

current_branch="$(git rev-parse --abbrev-ref HEAD)"
desired_branch="${UPDATER_SCRIPTS_BRANCH:-main}"
remote="${UPDATER_SCRIPTS_REMOTE:-origin}"

if [[ "$current_branch" != "$desired_branch" ]]
then
  git -C "$repo" checkout "$desired_branch"
fi

git -C "$repo" fetch "$remote" "$desired_branch" >&2

if [[ "$(git -C "$repo" rev-parse HEAD)" != "$(git -C "$repo" rev-parse FETCH_HEAD)" ]]
then
  git -C "$repo" pull
fi
