#!/bin/bash
# Remove legacy files left in $HOME after their chezmoi source counterparts
# were retired. Chezmoi doesn't auto-delete unmanaged files, so this script
# formalises the intent. Idempotent — `rm -rf` on missing paths is silent.
#
# Edit the `cleanups` list as you retire configs. Each entry is unconditional;
# if a path is here, it WILL be deleted on next apply.
set -e

cleanups=(
  # Superseded shell artifacts
  "$HOME/.zshrc.pre-oh-my-zsh"
  "$HOME/.zcompdump"

  # Retired Nushell configuration
  "$HOME/.config/nushell"

  # Bars / launchers we don't use
  "$HOME/.config/hyprpanel"
  "$HOME/.config/waybar"
  "$HOME/.config/caelestia"
  "$HOME/.config/wal"
  "$HOME/.config/ulauncher"

  # peon-ping: shipped 8 MB of sound packs but was never wired into
  # settings.json hooks, so it never played anything. Removed along with its
  # four control skills.
  "$HOME/.claude/hooks/peon-ping"
  "$HOME/.claude/skills/peon-ping-config"
  "$HOME/.claude/skills/peon-ping-log"
  "$HOME/.claude/skills/peon-ping-toggle"
  "$HOME/.claude/skills/peon-ping-use"
  "$HOME/.openpeon"
  "$HOME/.config/opencode/peon-ping"
)

for path in "${cleanups[@]}"; do
  if [ -e "$path" ]; then
    echo "Removing legacy: $path"
    rm -rf "$path"
  fi
done
