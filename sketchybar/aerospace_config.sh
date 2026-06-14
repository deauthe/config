#!/bin/bash

# Aerospace event integration for sketchybar
# This script sets up aerospace callbacks to trigger sketchybar updates

# Function to send aerospace events to sketchybar
send_aerospace_event() {
    local event_type="$1"
    local prev_workspace="$2"
    local current_workspace="$3"
    
    # Send the event to sketchybar with environment variables
    AEROSPACE_PREV_WORKSPACE="$prev_workspace" \
    AEROSPACE_FOCUSED_WORKSPACE="$current_workspace" \
    sketchybar --trigger aerospace_workspace_change
}

# This script should be called by aerospace callbacks
case "$1" in
    "workspace-change")
        send_aerospace_event "workspace_change" "$2" "$3"
        ;;
    "window-move")
        # Trigger update when windows are moved between workspaces
        current_workspace=$(aerospace list-workspaces --focused 2>/dev/null)
        send_aerospace_event "window_move" "" "$current_workspace"
        ;;
    *)
        # Default: just trigger a general update
        current_workspace=$(aerospace list-workspaces --focused 2>/dev/null)
        send_aerospace_event "update" "" "$current_workspace"
        ;;
esac 