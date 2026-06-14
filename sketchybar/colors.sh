#!/bin/bash

### Transparent Bar with White/Black Theme
export BLACK=0xff000000
export WHITE=0xffffffff
export RED=0xffff4444
export GREEN=0xff44ff44
export BLUE=0xff4444ff
export YELLOW=0xffffff44
export ORANGE=0xffff8844
export MAGENTA=0xffff44ff
export GREY=0xff888888
export TRANSPARENT=0x00000000

# Background colors for boxes
export LIGHT_BOX=0x80ffffff  # Semi-transparent white
export DARK_BOX=0x80000000   # Semi-transparent black

# Battery colors (keeping some color for status indication)
export BATTERY_1=0xff44ff44  # Green - Full
export BATTERY_2=0xffffff44  # Yellow - High  
export BATTERY_3=0xffff8844  # Orange - Medium
export BATTERY_4=0xffff4444  # Red - Low
export BATTERY_5=0xffaa0000  # Dark Red - Critical

# General bar colors
export BAR_COLOR=$TRANSPARENT           # Fully transparent bar
export BAR_BORDER_COLOR=$TRANSPARENT    # Transparent border
export BACKGROUND_1=$LIGHT_BOX          # Semi-transparent white boxes
export BACKGROUND_2=$DARK_BOX           # Semi-transparent black boxes for borders
export ICON_COLOR=$WHITE                # White icons
export LABEL_COLOR=$WHITE               # White labels
export POPUP_BACKGROUND_COLOR=$DARK_BOX # Semi-transparent black popups
export POPUP_BORDER_COLOR=$WHITE        # White popup borders
export SHADOW_COLOR=$BLACK              # Black shadows

