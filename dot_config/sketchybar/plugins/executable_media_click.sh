#!/usr/bin/env bash
case "$BUTTON" in
  right) nowplaying-cli next ;;
  *)     nowplaying-cli togglePlayPause ;;
esac
"$CONFIG_DIR/plugins/media.sh"
