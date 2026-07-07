#!/bin/bash
# Sync private Claude config (rayanrsr/dotclaude) into ~/.claude.
# The AI config (CLAUDE.md, settings.json, skills/, hooks/) lives in a PRIVATE
# repo, not in this (RayTerm) dotfiles repo. This clones/updates it and symlinks
# the pieces into ~/.claude.
#
# Requires ~/.netrc with a github.com entry whose token can read rayanrsr/dotclaude.
set -uo pipefail

DEST="$HOME/.local/share/dotclaude"
REPO="https://github.com/rayanrsr/dotclaude.git"

GHU=""; GHT=""
if [ -f "$HOME/.netrc" ]; then
  read -r GHU GHT < <(awk '{for(i=1;i<=NF;i++){if($i=="login")u=$(i+1);if($i=="password")p=$(i+1)}}END{print u,p}' "$HOME/.netrc")
fi
HELP="credential.helper=!f(){ echo username=${GHU:-x}; echo password=${GHT:-x}; };f"

if [ -d "$DEST/.git" ]; then
  git -C "$DEST" -c credential.helper= -c "$HELP" pull -q --ff-only \
    || echo "dotclaude: pull failed (offline?) — keeping existing checkout"
else
  git -c credential.helper= -c "$HELP" clone -q "$REPO" "$DEST" \
    || { echo "dotclaude: clone failed — is ~/.netrc set with a valid token?"; exit 0; }
fi

mkdir -p "$HOME/.claude"
# Directories: replace a real dir on first run, then keep as symlink.
for d in skills hooks; do
  L="$HOME/.claude/$d"
  [ -e "$L" ] && [ ! -L "$L" ] && rm -rf "$L"
  ln -sfn "$DEST/$d" "$L"
done
# settings.json
L="$HOME/.claude/settings.json"
[ -e "$L" ] && [ ! -L "$L" ] && rm -f "$L"
ln -sf "$DEST/settings.json" "$L"

# Agent rules: AGENTS.md is canonical. Claude reads CLAUDE.md, opencode reads AGENTS.md
# — both point at the same private file.
CL="$HOME/.claude/CLAUDE.md"
[ -e "$CL" ] && [ ! -L "$CL" ] && rm -f "$CL"
ln -sf "$DEST/AGENTS.md" "$CL"

mkdir -p "$HOME/.config/opencode"
OC="$HOME/.config/opencode/AGENTS.md"
[ -e "$OC" ] && [ ! -L "$OC" ] && rm -f "$OC"
ln -sf "$DEST/AGENTS.md" "$OC"

echo "dotclaude: ~/.claude + opencode AGENTS.md synced from rayanrsr/dotclaude"
