#!/usr/bin/env bash
set -euo pipefail

PLUGINS=(
  "danielsig/duckduckgo"
  "lmstudio/wikipedia"
  "danielsig/visit-website"
)

ensure_path() {
  export PATH="$HOME/.local/bin:$PATH"
}

install_lms_if_missing() {
  ensure_path

  if command -v lms >/dev/null 2>&1; then
    echo "✅ lms already installed: $(command -v lms)"
    return
  fi

  if ! command -v npx >/dev/null 2>&1; then
    echo "❌ npx not found. Please install Node.js (which provides npx)."
    exit 1
  fi

  echo "⬇️ Installing LM Studio CLI (lms)..."
  npx lmstudio install-cli

  ensure_path

  if ! command -v lms >/dev/null 2>&1; then
    echo "⚠️ lms installed but not in PATH yet. Open a new shell or add ~/.local/bin to PATH."
    exit 1
  fi

  echo "✅ lms installed successfully."
}

install_plugins() {
  for plugin in "${PLUGINS[@]}"; do
    echo "🔌 Installing plugin: $plugin"
    lms get "$plugin" || echo "⚠️ Failed to install $plugin (continuing)"
  done
}

install_lms_if_missing
install_plugins

echo "🎉 Done."
