#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '\d+%' | head -1 | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

case "$PERCENTAGE" in
  9[0-9]|100) ICON="󰁹"; COLOR="$SUCCESS";;
  [6-8][0-9])  ICON="󰂂"; COLOR="$TEXT";;
  [3-5][0-9])  ICON="󰁿"; COLOR="$WARN";;
  [1-2][0-9])  ICON="󰁼"; COLOR="$ERROR";;
  *)            ICON="󰂎"; COLOR="$ERROR";;
esac

if [ -n "$CHARGING" ]; then
  ICON="󰂄"
  COLOR="$ALT"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
