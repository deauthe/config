#!/usr/bin/env bash

# Source colors for consistent theming
source "$CONFIG_DIR/colors.sh"

# Function to refresh all workspace displays
refresh_all_workspaces() {
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
        # Get workspaces with apps
        workspaces_with_apps=$(aerospace list-workspaces --monitor "$monitor" --empty no)
        # Get empty workspaces
        empty_workspaces=$(aerospace list-workspaces --monitor "$monitor" --empty)
        # Get focused workspace
        focused_workspace=$(aerospace list-workspaces --focused)
        
        # Show workspaces with apps
        for workspace in $workspaces_with_apps; do
            sketchybar --set "space.$workspace" display="$monitor"
            
            # Update icons
            apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
            icon_strip=""
            if [ -n "$apps" ]; then
                while IFS= read -r app; do
                    if [ -n "$app" ]; then
                        icon_strip+="$($CONFIG_DIR/plugins/icon_map.sh "$app") "
                    fi
                done <<< "$apps"
                icon_strip=$(echo "$icon_strip" | sed 's/[[:space:]]*$//')
            else
                icon_strip="—"
            fi
            sketchybar --set "space.$workspace" label="$icon_strip"
        done
        
        # Handle empty workspaces
        for workspace in $empty_workspaces; do
            if [ "$workspace" = "$focused_workspace" ]; then
                # Show focused workspace even if empty
                sketchybar --set "space.$workspace" display="$monitor" label="—"
            else
                # Hide empty non-focused workspaces
                sketchybar --set "space.$workspace" display=0
            fi
        done
    done
    
    # Update focused workspace styling
    if [ -n "$focused_workspace" ]; then
        sketchybar --set "space.$focused_workspace" \
                   background.color=$BACKGROUND_2 \
                   background.border_color=$WHITE \
                   background.border_width=1 \
                   icon.color=$WHITE \
                   label.color=$WHITE \
                   icon.highlight=true \
                   label.highlight=true
    fi
}

# Initialize on startup
if [ "$SENDER" = "routine" ] || [ "$SENDER" = "" ]; then
    refresh_all_workspaces
fi 