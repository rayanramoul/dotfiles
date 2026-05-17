#!/usr/bin/env bash
# Click handler — open macOS Notification Center.
osascript -e 'tell application "System Events" to key code 113 using {fn down}' 2>/dev/null \
  || open "x-apple.systempreferences:com.apple.preference.notifications"
