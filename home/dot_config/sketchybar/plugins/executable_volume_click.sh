#!/usr/bin/env bash
# BUTTON: left=1 right=2 middle=3 ; sketchybar passes $BUTTON
case "$BUTTON" in
  right)
    osascript -e 'set volume output muted not (output muted of (get volume settings))'
    ;;
  *)
    open "/System/Library/PreferencePanes/Sound.prefPane"
    ;;
esac
sketchybar --trigger volume_change INFO=$(osascript -e 'output volume of (get volume settings)')
