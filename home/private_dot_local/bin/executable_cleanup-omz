#!/bin/bash

# Safe cleanup of oh-my-zsh installation

set -e

echo "Oh-My-Zsh Cleanup Script"
echo "========================"
echo ""

# Check if oh-my-zsh exists
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-My-Zsh directory not found at $HOME/.oh-my-zsh"
    echo "Nothing to clean up."
    exit 0
fi

# Create backup directory
BACKUP_DIR="$HOME/.oh-my-zsh-backup-$(date +%Y%m%d_%H%M%S)"
echo "Creating backup at: $BACKUP_DIR"

# Backup oh-my-zsh directory
if [ -d "$HOME/.oh-my-zsh" ]; then
    cp -r "$HOME/.oh-my-zsh" "$BACKUP_DIR"
    echo "✓ Backed up oh-my-zsh directory"
fi

# Backup p10k config if it exists
if [ -f "$HOME/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "$BACKUP_DIR/.p10k.zsh"
    echo "✓ Backed up powerlevel10k config"
fi

echo ""
echo "Backup completed. Now removing oh-my-zsh files..."
echo ""

# Remove oh-my-zsh directory
if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "✓ Removed ~/.oh-my-zsh"
fi

# Remove p10k config
if [ -f "$HOME/.p10k.zsh" ]; then
    rm -f "$HOME/.p10k.zsh"
    echo "✓ Removed ~/.p10k.zsh"
fi

# Remove oh-my-zsh cache
if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "✓ Removed oh-my-zsh cache"
fi

echo ""
echo "Oh-My-Zsh cleanup completed!"
echo ""
echo "Backup saved to: $BACKUP_DIR"
echo "To restore oh-my-zsh, run: mv $BACKUP_DIR ~/.oh-my-zsh"
echo ""
echo "Next steps:"
echo "1. Run the plugin installation script: ./scripts/install_zsh_plugins.sh"
echo "2. Restart your shell or run: source ~/.zshrc"
echo "3. Enjoy your clean zsh setup!" 