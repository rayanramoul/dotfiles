#!/bin/bash
# Reinstall my Zen Browser **mods** (Zen-specific UI mods from the theme-store,
# not standard Firefox extensions — those are in install-zen-extensions.sh).
#
# How Zen mods work:
#   ~/.config/zen/<profile>/zen-themes.json          ← manifest (which mods exist)
#   ~/.config/zen/<profile>/chrome/zen-themes/<id>/  ← per-mod CSS / prefs
#
# This script:
#   1. Locates the active Zen profile (must exist — open Zen once first).
#   2. Drops the manifest from ~/.config/zen-mods.json into the profile.
#   3. Downloads each mod's chrome.css (and preferences.json if any) from the
#      theme-store URLs the manifest references.
#   4. Restart Zen → mods active.
#
# Refresh the manifest from the live profile (e.g. after installing a new mod):
#   cp "$HOME/.config/zen/$(ls ~/.config/zen | grep '.Default').*/zen-themes.json" \
#      "$HOME/.local/share/chezmoi/dot_config/zen-mods.json"

set -e

ZEN_DIR="${ZEN_DIR:-$HOME/.config/zen}"
MANIFEST="${MANIFEST:-$HOME/.config/zen-mods.json}"

if [ ! -f "$MANIFEST" ]; then
  echo "Manifest $MANIFEST not found. Run \`chezmoi apply\` first." >&2
  exit 1
fi

if [ ! -d "$ZEN_DIR" ]; then
  echo "Zen has never run on this machine ($ZEN_DIR doesn't exist)." >&2
  echo "Open Zen once to let it create a profile, then re-run me." >&2
  exit 1
fi

# Read the *active* profile from profiles.ini. The [Install*] section's
# `Default=<relative-path>` is authoritative — `Default=1` flags on plain
# [ProfileN] sections are misleading when more than one profile exists.
PROFILES_INI="$ZEN_DIR/profiles.ini"
if [ ! -f "$PROFILES_INI" ]; then
  echo "$PROFILES_INI missing. Open Zen once first." >&2
  exit 1
fi

PROFILE_REL=$(awk -F= '
  /^\[Install/      { in_install=1; next }
  /^\[/             { in_install=0 }
  in_install && $1=="Default" { print $2; exit }
' "$PROFILES_INI")

if [ -z "$PROFILE_REL" ]; then
  echo "No [Install*] Default= line in $PROFILES_INI. Open Zen once first." >&2
  exit 1
fi

PROFILE_DIR="$ZEN_DIR/$PROFILE_REL"
if [ ! -d "$PROFILE_DIR" ]; then
  echo "Profile dir $PROFILE_DIR doesn't exist (profiles.ini stale)." >&2
  exit 1
fi

echo "Installing mods into: $PROFILE_DIR"

# Place the manifest.
install -Dm644 "$MANIFEST" "$PROFILE_DIR/zen-themes.json"

# Per-mod CSS + optional prefs.
jq -r 'to_entries[] | .value
       | "\(.id)\t\(.name)\t\(.style // "")\t\(.preferences // "")"' "$MANIFEST" \
| while IFS=$'\t' read -r id name style_url prefs_url; do
    dest="$PROFILE_DIR/chrome/zen-themes/$id"
    mkdir -p "$dest"
    printf '  → %-32s ' "$name"
    if [ -n "$style_url" ] && [ "$style_url" != "null" ]; then
      curl -fsSL "$style_url" -o "$dest/chrome.css"
      printf 'css '
    fi
    if [ -n "$prefs_url" ] && [ "$prefs_url" != "null" ]; then
      curl -fsSL "$prefs_url" -o "$dest/preferences.json"
      printf 'prefs'
    fi
    printf '\n'
  done

echo
echo "Done. Restart Zen to activate."
