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

chezmoi init --apply "$REPO_URL"