#!/bin/sh

# Add aerospace workspace change event
sketchybar --add event aerospace_workspace_change

# Function to update workspace icons
update_workspace_icons() {
    local workspace_id="$1"
    local monitor_id="$2"
    
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

# Create workspace items for each monitor
for monitor in $(aerospace list-monitors | awk '{print $1}'); do
    echo "Setting up monitor $monitor"
    
    # Get all workspaces for this monitor (both empty and non-empty)
    all_workspaces=$(aerospace list-workspaces --monitor "$monitor")
    
    for workspace in $all_workspaces; do
        # Create space item
        space_config=(
            space="$workspace"
            icon="$workspace"
            icon.highlight_color=$RED
            icon.padding_left=8
            icon.padding_right=8
            display="$monitor"
            padding_left=2
            padding_right=2
            label.padding_right=15
            label.color=$GREY
            label.highlight_color=$WHITE
            label.font="sketchybar-app-font:Regular:14.0"
            label.y_offset=-1
            background.color=$BACKGROUND_1
            background.border_color=$BACKGROUND_2
            background.corner_radius=6
            background.height=26
            script="$PLUGIN_DIR/space.sh"
        )
        
        # Add the space item
        sketchybar --add space "space.$workspace" left \
                   --set "space.$workspace" "${space_config[@]}" \
                   --subscribe "space.$workspace" mouse.clicked
        
        # Update icons for this workspace
        update_workspace_icons "$workspace" "$monitor"
    done
done

# Now update visibility based on actual content
focused_workspace=$(aerospace list-workspaces --focused)

for monitor in $(aerospace list-monitors | awk '{print $1}'); do
    all_workspaces=$(aerospace list-workspaces --monitor "$monitor")
    
    for workspace in $all_workspaces; do
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
    done
done

# Add monitor separator indicators
sketchybar --add item monitor_separator_1 left \
           --set monitor_separator_1 icon="󰍹" \
                                     icon.color=$GREY \
                                     icon.font="$FONT:Regular:12.0" \
                                     label.drawing=off \
                                     background.drawing=off \
                                     display=1

# Only add second monitor separator if monitor 2 exists
if aerospace list-monitors | grep -q "^2"; then
    sketchybar --add item monitor_separator_2 left \
               --set monitor_separator_2 icon="󰍺" \
                                         icon.color=$GREY \
                                         icon.font="$FONT:Regular:12.0" \
                                         label.drawing=off \
                                         background.drawing=off \
                                         display=2
fi

# Space creator/manager item
space_creator=(
    icon="󰐕"
    icon.font="$FONT:Heavy:14.0"
    icon.color=$WHITE
    padding_left=8
    padding_right=8
    label.drawing=off
    display=active
    script="$PLUGIN_DIR/space_windows.sh"
)

sketchybar --add item space_creator left \
           --set space_creator "${space_creator[@]}" \
           --subscribe space_creator aerospace_workspace_change
