#!/bin/sh
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
T="tmux -f $HOME/.config/ghostty/tmux/tmux.conf"

if ! $T has-session -t main 2>/dev/null; then
  exec $T new-session -s main
fi

if [ -z "$($T list-clients -t main 2>/dev/null)" ]; then
  exec $T attach-session -t main
fi

exec $T new-session
