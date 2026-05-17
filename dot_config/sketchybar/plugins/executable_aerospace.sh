#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$PILL_BG_HOT" \
    icon.color="$TEXT_ON_HOT" \
    label.color="$TEXT_ON_HOT"
else
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$PILL_BG_DIM" \
    icon.color="$TEXT_DIM" \
    label.color="$TEXT_DIM"
fi
