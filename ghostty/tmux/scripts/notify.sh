#!/bin/sh
title="$1"
body="$2"
pane="${3:-$TMUX_PANE}"
mode="$4"
export PATH="/opt/homebrew/bin:$PATH"
LOG="$HOME/.cache/ghostty-notify.log"
log() { echo "$(date +%T) $*" >> "$LOG"; }
log "called title=$title pane=$pane"

clean() { printf '%s' "$1" | tr -d '\033\007;' | cut -c1-200; }
seq=$(printf '\033]777;notify;%s;%s\033\\' "$(clean "$title")" "$(clean "$body")")

if [ -z "$TMUX" ] && [ -z "$pane" ]; then
  printf '%s' "$seq" > /dev/tty
  exit 0
fi

if [ "$mode" = skip-if-visible ] && [ -n "$pane" ]; then
  watching=$(tmux display -p -t "$pane" '#{session_name}|#{&&:#{window_active},#{pane_active}}' 2>/dev/null)
  session=${watching%|*}
  visible=${watching#*|}
  if [ "$visible" = 1 ] && tmux list-clients -F '#{client_session}|#{client_flags}' | grep -q "^$session|.*focused"; then
    log "skipped: pane visible and client focused"
    exit 0
  fi
fi

target=$(tmux list-clients -F '#{?#{m:*focused*,#{client_flags}},1,0} #{client_activity} #{client_tty}' | sort -rn | head -1)
focused=$(printf '%s' "$target" | cut -d' ' -f1)
tty=$(printf '%s' "$target" | cut -d' ' -f3)

if [ "$focused" = 1 ]; then
  if terminal-notifier -title "$(clean "$title")" -message "$(clean "$body")" -activate com.mitchellh.ghostty -sound default >/dev/null 2>&1; then
    log "sent via terminal-notifier (ghostty focused)"
  else
    osascript -e 'on run argv' -e 'display notification (item 2 of argv) with title (item 1 of argv) sound name "default"' -e 'end run' "$(clean "$title")" "$(clean "$body")" && log "sent via osascript (ghostty focused)"
  fi
elif [ -n "$tty" ]; then
  printf '%s' "$seq" > "$tty" && log "sent to $tty"
else
  log "no client tty"
fi
