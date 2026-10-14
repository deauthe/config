#!/bin/bash
export PATH=/opt/homebrew/bin:$PATH
list=$(aerospace list-windows --all --format '%{window-id}|%{app-name} — %{window-title}  [%{workspace}]' | grep -v '^0|')
[ -z "$list" ] && exit 0
if command -v choose >/dev/null; then
  pick=$(echo "$list" | cut -d'|' -f2- | choose -i) || exit 0
  id=$(echo "$list" | grep -F "|$pick" | head -1 | cut -d'|' -f1)
else
  items=$(echo "$list" | cut -d'|' -f2- | sed 's/"/\\"/g' | awk '{printf "%s\"%s\"", (NR>1?",":""), $0}')
  pick=$(osascript -e "choose from list {$items} with prompt \"Go to window\"" 2>/dev/null)
  [ "$pick" = "false" ] || [ -z "$pick" ] && exit 0
  id=$(echo "$list" | grep -F "|$pick" | head -1 | cut -d'|' -f1)
fi
[ -n "$id" ] && aerospace focus --window-id "$id"
