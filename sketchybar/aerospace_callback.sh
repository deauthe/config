#!/bin/bash

# Aerospace callback wrapper for sketchybar
# This script receives environment variables from aerospace and triggers sketchybar

echo "Aerospace callback: PREV=$AEROSPACE_PREV_WORKSPACE FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE" >> /tmp/aerospace_callback.log

# Write workspace information to a file that sketchybar scripts can read
echo "$AEROSPACE_PREV_WORKSPACE" > /tmp/aerospace_prev_workspace
echo "$AEROSPACE_FOCUSED_WORKSPACE" > /tmp/aerospace_focused_workspace

# Trigger sketchybar event
/opt/homebrew/opt/sketchybar/bin/sketchybar --trigger aerospace_workspace_change

echo "Sketchybar trigger sent" >> /tmp/aerospace_callback.log 