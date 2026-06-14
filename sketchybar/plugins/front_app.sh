#!/usr/bin/env bash

# Source colors and icons for consistent theming
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Get the current application
if [ "$SENDER" = "front_app_switched" ]; then
    APP_NAME="$INFO"
else
    # Use AppleScript to get the frontmost application since we're using aerospace, not yabai
    APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo "Unknown")
fi

# Icon mapping for common applications
case $APP_NAME in
    "Cursor")
        ICON="󰨞"
        ;;
    "Visual Studio Code")
        ICON="󰨞"
        ;;
    "Slack")
        ICON="󰒱"
        ;;
    "Discord")
        ICON="󰙯"
        ;;
    "Google Chrome")
        ICON="󰊯"
        ;;
    "Safari")
        ICON="󰀹"
        ;;
    "Firefox")
        ICON="󰈹"
        ;;
    "Terminal")
        ICON="󰆍"
        ;;
    "iTerm2")
        ICON="󰆍"
        ;;
    "WezTerm")
        ICON="󰆍"
        ;;
    "Finder")
        ICON="󰀶"
        ;;
    "Spotify")
        ICON="󰓇"
        ;;
    "Music")
        ICON="󰎆"
        ;;
    "Mail")
        ICON="󰇮"
        ;;
    "Messages")
        ICON="󰍦"
        ;;
    "FaceTime")
        ICON="󰍫"
        ;;
    "Zoom")
        ICON="󰊶"
        ;;
    "Notion")
        ICON="󰈭"
        ;;
    "Obsidian")
        ICON="󰈭"
        ;;
    "Xcode")
        ICON="󰙳"
        ;;
    "Docker")
        ICON="󰡨"
        ;;
    "Figma")
        ICON="󰤼"
        ;;
    "Sketch")
        ICON="󰤼"
        ;;
    "Photoshop")
        ICON="󰤿"
        ;;
    "System Preferences")
        ICON="󰒓"
        ;;
    "System Settings")
        ICON="󰒓"
        ;;
    "Activity Monitor")
        ICON="󰖚"
        ;;
    "Arc")
        ICON="󰞍"
        ;;
    "Vivaldi")
        ICON="󰊯"
        ;;
    "The Browser Company")
        ICON="󰞍"
        ;;
    "Warp")
        ICON="󰆍"
        ;;
    *)
        # Default icon for unknown applications
        ICON="󰄛"
        ;;
esac

# Update the front_app item
sketchybar --set "$NAME" icon="$ICON" \
                        icon.color=$WHITE \
                        label="$APP_NAME" \
                        label.color=$WHITE

# Also update the current workspace icons when front app changes
if [ "$SENDER" = "front_app_switched" ]; then
    CURRENT_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
    if [ -n "$CURRENT_WORKSPACE" ] && [ -f "$CONFIG_DIR/plugins/space_windows.sh" ]; then
        # Trigger workspace icon update
        source "$CONFIG_DIR/plugins/space_windows.sh"
        reload_workspace_icon "$CURRENT_WORKSPACE" 2>/dev/null || true
    fi
fi
