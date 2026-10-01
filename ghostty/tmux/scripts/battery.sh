#!/bin/sh
info=$(pmset -g batt | tail -1)
pct=$(printf '%s' "$info" | grep -Eo '[0-9]+%' | tr -d '%')
[ -z "$pct" ] && exit 0

if printf '%s' "$info" | grep -qE 'charging|charged|AC attached'; then
  icon="󰂄"
elif [ "$pct" -ge 80 ]; then icon="󰁹"
elif [ "$pct" -ge 50 ]; then icon="󰁾"
elif [ "$pct" -ge 20 ]; then icon="󰁻"
else icon="#[fg=#c4848c]󰂃"
fi

printf '%s %s%%' "$icon" "$pct"
