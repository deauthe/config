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

# Get current aerospace state
AEROSPACE_FOCUSED_MONITOR=$(aerospace list-monitors --focused | awk '{print $1}')
AEROSPACE_WORKSPACE_FOCUSED_MONITOR=$(aerospace list-workspaces --monitor focused --empty no)
AEROSPACE_EMPTY_WORKSPACE=$(aerospace list-workspaces --monitor focused --empty)
CURRENT_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

reload_workspace_icon() {
  local workspace_id="$1"
  apps=$(aerospace list-windows --workspace "$workspace_id" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
    done <<< "${apps}"
  else
    icon_strip=" —"
  fi

  sketchybar --animate sin 10 --set space.$workspace_id label="$icon_strip"
}

if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Get the focused workspace directly from aerospace
  FOCUSED_WS=$(aerospace list-workspaces --focused)
  
  # Update workspace icons for all workspaces (since we don't have prev/current from env vars)
  for workspace in $(aerospace list-workspaces --all); do
    reload_workspace_icon "$workspace"
    
    if [ "$workspace" = "$FOCUSED_WS" ]; then
      # Highlight the focused workspace
      sketchybar --set space.$workspace \
                 icon.highlight=true \
                 label.highlight=true \
                 background.border_color=$BLUE
    else
      # Remove highlighting from non-focused workspaces
      sketchybar --set space.$workspace \
                 icon.highlight=false \
                 label.highlight=false \
                 background.border_color=$BACKGROUND_2
    fi
  done

  # Show workspaces with windows on focused monitor
  for i in $AEROSPACE_WORKSPACE_FOCUSED_MONITOR; do
    sketchybar --set space.$i display=$AEROSPACE_FOCUSED_MONITOR
  done

  # Hide empty workspaces
  for i in $AEROSPACE_EMPTY_WORKSPACE; do
    sketchybar --set space.$i display=0
  done

  # Ensure focused workspace is always visible
  if [ -n "$FOCUSED_WS" ]; then
    sketchybar --set space.$FOCUSED_WS display=$AEROSPACE_FOCUSED_MONITOR
  fi
fi
