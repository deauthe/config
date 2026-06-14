#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Get current workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
WORKSPACE_ID="$1"

# If no workspace ID provided, use the NAME variable from sketchybar
if [ -z "$WORKSPACE_ID" ]; then
    WORKSPACE_ID="${NAME#space.}"
fi

# Skip processing if no valid workspace ID
if [ -z "$WORKSPACE_ID" ]; then
    exit 0
fi

# Function to reload workspace icons
reload_workspace_icon() {
    local workspace_id="$1"
    apps=$(aerospace list-windows --workspace "$workspace_id" 2>/dev/null | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
        while read -r app; do
            if [ -n "$app" ]; then
                icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
            fi
        done <<< "${apps}"
    else
        icon_strip=" —"
    fi

    sketchybar --set "space.$workspace_id" label="$icon_strip"
}

# Check if any windows exist in this workspace
WORKSPACE_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l)

if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace styling
    sketchybar --set "$NAME" \
               background.drawing=on \
               background.color=$BACKGROUND_1 \
               background.corner_radius=6 \
               background.height=24 \
               background.border_width=1 \
               background.border_color=$BLUE \
               icon.color=$BLUE \
               icon.font="SF Pro:Bold:14.0" \
               icon.highlight=true \
               label.color=$WHITE \
               label.highlight=true \
               drawing=on
else
    # Check if workspace has windows
    if [ "$WORKSPACE_WINDOWS" -gt 0 ]; then
        # Workspace with windows but not focused
        sketchybar --set "$NAME" \
                   background.drawing=on \
                   background.color=$BACKGROUND_1 \
                   background.corner_radius=6 \
                   background.height=24 \
                   background.border_width=1 \
                   background.border_color=$BACKGROUND_2 \
                   icon.color=$ICON_COLOR \
                   icon.font="SF Pro:Medium:14.0" \
                   icon.highlight=false \
                   label.color=$GREY \
                   label.highlight=false \
                   drawing=on
    else
        # Empty workspace - hide it unless it's focused
        sketchybar --set "$NAME" display=0
    fi
fi

# Update workspace content
reload_workspace_icon "$WORKSPACE_ID"
