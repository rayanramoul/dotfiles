#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Refresh from event or poll
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi

MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

if [ "$MUTED" = "true" ]; then
  ICON="󰖁"
  COLOR="$ERROR"
else
  case "$VOLUME" in
    [6-9][0-9]|100) ICON="󰕾";;
    [3-5][0-9])     ICON="󰖀";;
    [1-9]|[1-2][0-9]) ICON="󰕿";;
    *)              ICON="󰖁";;
  esac
  COLOR="$TEXT"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${VOLUME}%"
