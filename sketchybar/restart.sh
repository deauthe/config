#!/usr/bin/env bash

# Kill existing sketchybar instances
killall sketchybar

# Wait a moment for processes to terminate
sleep 1

# Start sketchybar with new configuration
sketchybar --config "$HOME/.config/sketchybar/sketchybarrc"

echo "SketchyBar restarted with enhanced features!"
echo "✨ Features included:"
echo "  • Proper aerospace workspace switching"
echo "  • Empty workspaces are hidden automatically"
echo "  • Click workspaces to switch"
echo "  • Shift+click to rename workspaces"
echo "  • Dynamic workspace icons based on running apps"
echo "  • Multi-monitor support"
echo "  • Enhanced volume control with popup (click to open)"
echo "  • Smart battery indicator with color-coded levels"
echo "  • Real-time front app detection (no yabai needed)"
echo "  • Calendar integration showing upcoming events"
echo "  • Enhanced clock with date and popup info (click to open)"
