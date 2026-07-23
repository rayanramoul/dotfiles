#!/usr/bin/env bash
# Show focused app name. Reads the system rather than relying solely on the
# front_app_switched event, so the label is populated on bar restart.

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  APP="$INFO"
else
  APP=$(osascript -e 'tell application "System Events" to get name of (first process whose frontmost is true)' 2>/dev/null)
fi

sketchybar --set "$NAME" label="$APP"
