#!/bin/bash
# Remove legacy files left in $HOME after their chezmoi source counterparts
# were retired. Chezmoi doesn't auto-delete unmanaged files, so this script
# formalises the intent. Idempotent — `rm -rf` on missing paths is silent.
#
# Edit the `cleanups` list as you retire configs. Each entry is unconditional;
# if a path is here, it WILL be deleted on next apply.
set -e

cleanups=(
  # zsh + p10k era
  "$HOME/.zshrc"
  "$HOME/.zshrc.pre-oh-my-zsh"
  "$HOME/.p10k.zsh"
  "$HOME/.zcompdump"

  # Nushell era (migrated to xonsh)
  "$HOME/.config/nushell"

  # Bars / launchers we don't use
  "$HOME/.config/hyprpanel"
  "$HOME/.config/waybar"
  "$HOME/.config/caelestia"
  "$HOME/.config/wal"
  "$HOME/.config/ulauncher"
)

for path in "${cleanups[@]}"; do
  if [ -e "$path" ]; then
    echo "Removing legacy: $path"
    rm -rf "$path"
  fi
done
