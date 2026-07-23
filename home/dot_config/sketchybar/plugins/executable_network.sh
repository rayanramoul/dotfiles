#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Modern macOS (14+) redacts SSID unless Location Services is granted, so this
# plugin focuses on connectivity + interface type rather than network name.

DEFAULT_IF=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')

if [ -z "$DEFAULT_IF" ]; then
  ICON="󰅪"
  LABEL="offline"
  COLOR="$ERROR"
else
  KIND=$(networksetup -listallhardwareports 2>/dev/null \
         | awk -v dev="$DEFAULT_IF" '
             /Hardware Port:/{port=$0; sub(/^Hardware Port: /, "", port)}
             /Device:/{if ($2==dev) {print port; exit}}')

  case "$KIND" in
    *Wi-Fi*|*AirPort*)              ICON="󰖩";  LABEL="Wi-Fi";;
    *USB*|*Thunderbolt*|*Ethernet*) ICON="󰈀"; LABEL="ethernet";;
    *)                              ICON="󰋼"; LABEL="online";;
  esac
  COLOR="$SUCCESS"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
