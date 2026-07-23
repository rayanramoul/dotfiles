#!/bin/bash
# Open AMO landing pages for each Zen-browser extension I keep installed,
# so a fresh box becomes "just click Add to Firefox" instead of "rediscover
# every addon by name".
#
# Simpler alternative: enable Mozilla Sync in Zen (Settings → Account →
# Sign in). That syncs extensions + bookmarks across machines automatically.
# This script is the "no-account, declarative, in-git" equivalent.
#
# To refresh this list from the live Zen profile:
#   PROF="$HOME/.config/zen/$(ls ~/.config/zen | grep '.Default')"
#   jq -r '.addons[]? | select(.type=="extension" and .active==true
#          and (.id|contains("@mozilla")|not)) | "\(.defaultLocale.name)|\(.id)"' \
#     "$PROF/extensions.json"

set -e

BROWSER="${BROWSER:-zen-browser}"
if ! command -v "$BROWSER" >/dev/null 2>&1; then
  echo "$BROWSER not found on PATH (override with BROWSER=zen)" >&2
  exit 1
fi

# format: "Friendly Name|addon-GUID-from-AMO"
addons=(
  "uBlock Origin|uBlock0@raymondhill.net"
  "Return YouTube Dislike|{762f9885-5a13-4abd-9c77-433dcd38b8fd}"
  "Reddit Enhancement Suite|jid1-xUfzOsOFlzSOXg@jetpack"
  "Augmented Steam|{1be309c5-3e4f-4b99-927d-bb500eb4fa88}"
  "Keepa - Amazon Price Tracker|amptra@keepa.com"
  "YouTube Enhancer|{c49b13b1-5dee-4345-925e-0c793377e3fa}"
  "SteamDB|firefox-extension@steamdb.info"
  "Obsidian Web Clipper|clipper@obsidian.md"
  "SponsorBlock|sponsorBlocker@ajay.app"
  "Refined GitHub|{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}"
  "BetterTTV|firefox@betterttv.net"
  "Proton Pass|78272b6fa58f4a1abaac99321d503a20@proton.me"
  "Zen Internet|{91aa3897-2634-4a8a-9092-279db23a7689}"
)

echo "Opening ${#addons[@]} addon pages in $BROWSER."
echo "Click 'Add to Firefox' on each one. Zen accepts standard Firefox addons."
echo

for entry in "${addons[@]}"; do
  name="${entry%%|*}"
  id="${entry##*|}"
  # AMO API resolves the GUID to its canonical landing-page URL.
  url=$(curl -fsSL "https://addons.mozilla.org/api/v5/addons/addon/${id}/" 2>/dev/null \
        | jq -r '.url // empty' 2>/dev/null)
  if [ -z "$url" ]; then
    printf '  ✗ %-32s (GUID %s — not resolvable, search AMO manually)\n' "$name" "$id"
    continue
  fi
  printf '  → %-32s %s\n' "$name" "$url"
  "$BROWSER" "$url" &
  sleep 0.4
done

wait
echo
echo "Done. If any popups got blocked, run me again with BROWSER=zen or open the listed URLs manually."
