#!/usr/bin/env bash
 
echo AEROSPACE_PREV_WORKSPACE: $AEROSPACE_PREV_WORKSPACE, \
 AEROSPACE_FOCUSED_WORKSPACE: $AEROSPACE_FOCUSED_WORKSPACE \
 SELECTED: $SELECTED \
 BG2: $BG2 \
 INFO: $INFO \
 SENDER: $SENDER \
 NAME: $NAME \
  >> ~/aaaa

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
    sketchybar --animate sin 10 --set "space.$workspace_id" label="$icon_strip"
}

# Function to show/hide workspaces based on content
update_workspace_visibility() {
    # Get focused workspace
    focused_workspace=$(aerospace list-workspaces --focused)
    
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
        # Get ALL workspaces for this monitor
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
}

# Function to update all workspace icons
update_all_workspace_icons() {
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
        all_workspaces=$(aerospace list-workspaces --monitor "$monitor")
        for workspace in $all_workspaces; do
            update_workspace_icons "$workspace"
        done
    done
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    # Update all workspace icons (not just focused and previous)
    update_all_workspace_icons
    
    # Update workspace visibility
    update_workspace_visibility
    
    # Update highlighting for focused workspace
    if [ -n "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
        sketchybar --set "space.$AEROSPACE_FOCUSED_WORKSPACE" \
                   icon.highlight=true \
                   label.highlight=true \
                   background.border_color=$WHITE \
                   background.border_width=1 \
                   background.color=$BACKGROUND_2
    fi
    
    # Remove highlighting from previous workspace
    if [ -n "$AEROSPACE_PREV_WORKSPACE" ] && [ "$AEROSPACE_PREV_WORKSPACE" != "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
        sketchybar --set "space.$AEROSPACE_PREV_WORKSPACE" \
                   icon.highlight=false \
                   label.highlight=false \
                   background.border_color=$BACKGROUND_2 \
                   background.border_width=0 \
                   background.color=$BACKGROUND_1
    fi
    
    # Update monitor separators to show which monitor is focused
    focused_monitor=$(aerospace list-monitors --focused | awk '{print $1}')
    
    # Update monitor separator colors based on focus
    for monitor in $(aerospace list-monitors | awk '{print $1}'); do
        if [ "$monitor" = "$focused_monitor" ]; then
            sketchybar --set "monitor_separator_$monitor" icon.color=$WHITE
        else
            sketchybar --set "monitor_separator_$monitor" icon.color=$GREY
        fi
    done
fi
