#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Function to update workspace icons
update_workspace_icons() {
    local workspace_id="$1"
    
    # Get apps in this workspace
    apps=$(aerospace list-windows --workspace "$workspace_id" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    
    # Build icon strip
    icon_strip=""
    if [ -n "$apps" ]; then
        while IFS= read -r app; do
            if [ -n "$app" ]; then
                icon_strip+="$($CONFIG_DIR/plugins/icon_map.sh "$app") "
            fi
        done <<< "$apps"
        # Remove trailing space
        icon_strip=$(echo "$icon_strip" | sed 's/[[:space:]]*$//')
    fi
    
    # If no apps, show dash
    if [ -z "$icon_strip" ]; then
        icon_strip="—"
    fi
    
    # Update the workspace item
    sketchybar --set "space.$workspace_id" label="$icon_strip"
}

# Get focused workspace
focused_workspace=$(aerospace list-workspaces --focused)

# Process all monitors and workspaces
for monitor in $(aerospace list-monitors | awk '{print $1}'); do
    all_workspaces=$(aerospace list-workspaces --monitor "$monitor")
    
    for workspace in $all_workspaces; do
        # Update icons
        update_workspace_icons "$workspace"
        
        # Check if workspace has apps
        apps=$(aerospace list-windows --workspace "$workspace" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
        
        if [ -n "$apps" ]; then
            # Show workspace if it has apps
            sketchybar --set "space.$workspace" display="$monitor"
        elif [ "$workspace" = "$focused_workspace" ]; then
            # Show focused workspace even if empty
            sketchybar --set "space.$workspace" display="$monitor"
        else
            # Hide empty non-focused workspaces
            sketchybar --set "space.$workspace" display=0
        fi
        
        # Update styling based on focus
        if [ "$workspace" = "$focused_workspace" ]; then
            sketchybar --set "space.$workspace" \
                       icon.highlight=true \
                       label.highlight=true \
                       background.border_color=$WHITE \
                       background.border_width=1 \
                       background.color=$BACKGROUND_2 \
                       icon.color=$WHITE \
                       label.color=$WHITE
        else
            sketchybar --set "space.$workspace" \
                       icon.highlight=false \
                       label.highlight=false \
                       background.border_color=$BACKGROUND_2 \
                       background.border_width=0 \
                       background.color=$BACKGROUND_1 \
                       icon.color=$GREY \
                       label.color=$GREY
        fi
    done
done

echo "Refreshed all workspaces" 