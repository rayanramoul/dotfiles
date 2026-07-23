#!/usr/bin/env bash
# Refresh the open-app "tray" — runs single-instance via flock, no-ops if app
# set hasn't changed since last run.
set -u
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icon_map.sh"

LOCK="/tmp/sketchybar-apps.pid"
if [ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  exit 0
fi
echo $$ > "$LOCK"
trap 'rm -f "$LOCK"' EXIT INT TERM

CACHE="$HOME/.cache/sketchybar-apps"
mkdir -p "$(dirname "$CACHE")"

NEW=$(aerospace list-windows --all --json 2>/dev/null \
       | jq -r '.[]["app-name"]' \
       | sort -u)

OLD=""
[ -f "$CACHE" ] && OLD=$(cat "$CACHE")

[ "$NEW" = "$OLD" ] && exit 0
printf '%s\n' "$NEW" > "$CACHE"

# Remove previous app.* items
PREV=$(sketchybar --query bar 2>/dev/null | jq -r '.items[]?' | grep '^app\.' || true)
for item in $PREV; do
  sketchybar --remove "$item" >/dev/null 2>&1
done

# Build a single batched command for the new set
ARGS=()
INDEX=0
while IFS= read -r app; do
  [ -z "$app" ] && continue
  __icon_map "$app"
  ARGS+=( --add item "app.$INDEX" left
          --set "app.$INDEX"
              icon="$icon_result"
              icon.font="$APP_FONT"
              icon.color="$TEXT"
              icon.padding_left=3
              icon.padding_right=3
              label.drawing=off
              background.drawing=off
              click_script="open -a \"$app\"" )
  INDEX=$((INDEX + 1))
done <<< "$NEW"

[ "${#ARGS[@]}" -gt 0 ] && sketchybar "${ARGS[@]}" >/dev/null 2>&1
