#!/bin/sh
cd "$1" 2>/dev/null || exit 0
branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || exit 0
[ -z "$branch" ] && exit 0

dirty=""
[ -n "$(git status --porcelain --untracked-files=no 2>/dev/null | head -1)" ] && dirty=" #[fg=#cfb98f]●"

max=${2:-24}
if [ ${#branch} -gt "$max" ]; then
  branch="$(printf '%s' "$branch" | cut -c1-$((max - 1)))…"
fi

printf '󰘬 %s%s' "$branch" "$dirty"
