#!/bin/bash
# Install the rose-pine kvantum theme from upstream.
# No AUR package exists for this theme; the official source distributes per-flavor
# tarballs at https://github.com/rose-pine/kvantum/tree/master/dist .
#
# Idempotent — exits early if the theme dir already exists. Bump $THEME to switch
# flavor/accent (see the dist/ listing for available variants).
set -e

DEST="$HOME/.config/Kvantum"
THEME="rose-pine-love"
URL="https://raw.githubusercontent.com/rose-pine/kvantum/master/dist/${THEME}.tar.gz"

if [ -d "$DEST/$THEME" ]; then
  exit 0
fi

mkdir -p "$DEST"
echo "Installing kvantum theme $THEME from upstream..."
curl -fsSL "$URL" | tar -xzf - -C "$DEST"
echo "  → $DEST/$THEME"
