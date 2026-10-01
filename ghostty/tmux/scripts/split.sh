#!/bin/sh
dir="$1"
path="$2"

if [ "$dir" = h ]; then
  total=$(tmux display -p '#{pane_width}'); flag=-h; axis=-x
else
  total=$(tmux display -p '#{pane_height}'); flag=-v; axis=-y
fi

target=$(( (total - 1) / 2 ))
start=$(( target / 6 ))
[ "$start" -lt 2 ] && start=2

pane=$(tmux split-window $flag -l "$start" -c "$path" -P -F '#{pane_id}') || exit 1

for f in 40 68 86 96 100; do
  tmux resize-pane -t "$pane" $axis $(( start + (target - start) * f / 100 ))
  sleep 0.012
done
