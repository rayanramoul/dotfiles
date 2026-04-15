#!/bin/sh
# Deploy user.js to all Zen browser profiles
# hash: {{ include "dot_config/zen/user.js" | sha256sum }}

ZEN_DIR="$HOME/.config/zen"

if [ ! -d "$ZEN_DIR" ]; then
  exit 0
fi

find "$ZEN_DIR" -maxdepth 1 -type d | while read -r profile; do
  if [ -f "$profile/prefs.js" ]; then
    cp "$HOME/.config/zen/user.js" "$profile/user.js"
    echo "Deployed user.js to $profile"
  fi
done
