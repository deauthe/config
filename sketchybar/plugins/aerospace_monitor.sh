#!/bin/bash

# Aerospace workspace monitor for sketchybar
# This script continuously monitors aerospace workspace changes and triggers sketchybar updates

PREVIOUS_WORKSPACE=""
PREVIOUS_WINDOWS_STATE=""

while true; do
    # Get current workspace
    CURRENT_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
    
    # Get current windows state (to detect window moves)
    CURRENT_WINDOWS_STATE=$(aerospace list-windows --all 2>/dev/null | md5sum | cut -d' ' -f1)
    
    # Check if workspace changed
    if [ "$CURRENT_WORKSPACE" != "$PREVIOUS_WORKSPACE" ] && [ -n "$CURRENT_WORKSPACE" ]; then
        # Send workspace change event to sketchybar
        AEROSPACE_PREV_WORKSPACE="$PREVIOUS_WORKSPACE" \
        AEROSPACE_FOCUSED_WORKSPACE="$CURRENT_WORKSPACE" \
        sketchybar --trigger aerospace_workspace_change
        
        PREVIOUS_WORKSPACE="$CURRENT_WORKSPACE"
    fi
    
    # Check if windows state changed (windows moved, opened, closed)
    if [ "$CURRENT_WINDOWS_STATE" != "$PREVIOUS_WINDOWS_STATE" ] && [ -n "$CURRENT_WINDOWS_STATE" ]; then
        # Trigger space windows change event
        AEROSPACE_FOCUSED_WORKSPACE="$CURRENT_WORKSPACE" \
        sketchybar --trigger space_windows_change
        
        PREVIOUS_WINDOWS_STATE="$CURRENT_WINDOWS_STATE"
    fi
    
    # Sleep for a short interval (adjust as needed for responsiveness vs CPU usage)
    sleep 0.5
done 