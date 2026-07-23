#!/usr/bin/env bash
set -e

REPO="https://github.com/rayanramoul/dotfiles"

if ! command -v chezmoi &>/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)"
fi

if ssh -T git@github.com 2>&1 | grep -qE "(authenticated|Hi .+! You've successfully authenticated)"; then
    REPO_URL="git@github.com:rayanramoul/dotfiles"
else
    REPO_URL="$REPO"
fi

chezmoi init "$REPO_URL"

KEY_FILE="$HOME/.config/chezmoi/key.txt"
if [ -n "${CHEZMOI_AGE_KEY_FILE:-}" ] && [ ! -f "$KEY_FILE" ]; then
    install -Dm600 "$CHEZMOI_AGE_KEY_FILE" "$KEY_FILE"
fi

if [ ! -f "$KEY_FILE" ]; then
    printf '%s\n' \
        "Chezmoi was initialized, but encrypted files require the age identity." \
        "Restore it to $KEY_FILE with mode 0600, then run: chezmoi apply"
    exit 1
fi

chmod 600 "$KEY_FILE"
chezmoi apply
