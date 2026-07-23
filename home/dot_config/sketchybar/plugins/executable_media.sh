#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

if ! command -v nowplaying-cli >/dev/null 2>&1; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

STATE=$(nowplaying-cli get playbackRate 2>/dev/null)
TITLE=$(nowplaying-cli get title 2>/dev/null)
ARTIST=$(nowplaying-cli get artist 2>/dev/null)

# Hide when nothing is playing or no title
if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# 1 = playing, 0 = paused
if [ "$STATE" = "1" ]; then
  ICON="󰐊"; COLOR="$TEXT"
else
  ICON="󰏤"; COLOR="$TEXT_DIM"
fi

if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
  LABEL="$ARTIST — $TITLE"
else
  LABEL="$TITLE"
fi

# Truncate long labels
if [ ${#LABEL} -gt 32 ]; then
  LABEL="${LABEL:0:30}…"
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color="$COLOR" label="$LABEL"
