#!/bin/bash

source "$CONFIG_DIR/colors.sh"

update() {
  if [ "$SENDER" = "aerospace_workspace_change" ]; then
    # Get focused workspace directly from aerospace
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
    
    # Update focused workspace highlighting
    if [ -n "$FOCUSED_WORKSPACE" ]; then
      sketchybar --set space.$FOCUSED_WORKSPACE \
                 icon.highlight=true \
                 label.highlight=true \
                 background.border_color=$BLUE
    fi
    
    # Remove highlighting from all other workspaces
    for workspace in $(aerospace list-workspaces --all); do
      if [ "$workspace" != "$FOCUSED_WORKSPACE" ]; then
        sketchybar --set space.$workspace \
                   icon.highlight=false \
                   label.highlight=false \
                   background.border_color=$BACKGROUND_2
      fi
    done
  fi
}

set_space_label() {
  sketchybar --set $NAME icon="$@"
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    # Right click - could add context menu here
    echo ''
  else
    if [ "$MODIFIER" = "shift" ]; then
      # Shift+click - rename workspace
      SPACE_LABEL="$(osascript -e "return (text returned of (display dialog \"Give a name to space $NAME:\" default answer \"\" with icon note buttons {\"Cancel\", \"Continue\"} default button \"Continue\"))")"
      if [ $? -eq 0 ]; then
        if [ "$SPACE_LABEL" = "" ]; then
          set_space_label "${NAME:6}"
        else
          set_space_label "${NAME:6} ($SPACE_LABEL)"
        fi
      fi
    else
      # Regular click - switch to workspace
      aerospace workspace ${NAME#*.}
    fi
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
