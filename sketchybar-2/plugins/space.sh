#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Handle mouse clicks on workspace items
if [ "$SENDER" = "mouse.clicked" ]; then
    # Extract workspace ID from the item name (space.X -> X)
    WORKSPACE_ID=$(echo "$NAME" | sed 's/space\.//')
    
    # Focus the workspace using aerospace
    aerospace workspace "$WORKSPACE_ID"
    
    exit 0
fi

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected
# Get the workspace ID from the name
WORKSPACE_ID=$(echo "$NAME" | sed 's/space\.//')

# Get the currently focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Update appearance based on selection
if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace styling
    sketchybar --set "$NAME" \
               background.drawing=on \
               background.color=$BACKGROUND_2 \
               background.border_color=$WHITE \
               background.border_width=1 \
               icon.color=$WHITE \
               label.color=$WHITE \
               icon.highlight=true \
               label.highlight=true
else
    # Inactive workspace styling
    sketchybar --set "$NAME" \
               background.drawing=on \
               background.color=$BACKGROUND_1 \
               background.border_color=$BACKGROUND_2 \
               background.border_width=0 \
               icon.color=$GREY \
               label.color=$GREY \
               icon.highlight=false \
               label.highlight=false
fi
