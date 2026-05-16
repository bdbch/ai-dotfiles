#!/bin/bash

OPENCODE_DIR="$HOME/.config/opencode"
BACKUP_DIR="$HOME/.config/opencode_backup_$(date +%Y%m%d%H%M%S)"

# Migrate / Backup old opensource folder
if [ -d "$OPENCODE_DIR" ]; then
    # If the existing configuration is a symbolic link, we can remove it without backup
    if [ -L "$OPENCODE_DIR" ]; then
        echo "Existing Opencode configuration is a symbolic link. Removing it."
        rm "$OPENCODE_DIR"
    else
        echo "Existing Opencode configuration found. Backing up to $BACKUP_DIR"
        mv "$OPENCODE_DIR" "$BACKUP_DIR"
        echo "Backup completed."
    fi
fi

# Find the root directory of the ai-dotfiles repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Error: This script must be run from within a git repository."
    exit 1
fi

# Create a symbolic link to the new opencode configuration
echo "Creating symbolic link for Opencode configuration..."
ln -s "$REPO_ROOT/.config/opencode" "$OPENCODE_DIR"

echo "Opencode configuration has been set up successfully."
echo "You can find the new configuration at $OPENCODE_DIR"