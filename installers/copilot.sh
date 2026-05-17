#!/bin/bash

COPILOT_DIR="$HOME/.copilot"
BACKUP_DIR="$HOME/.backups/.copilot_backup_$(date +%Y%m%d%H%M%S)"
BACKUP_RUN=false

# Back up old configuration
mkdir -p "$BACKUP_DIR"
if [ -d "$COPILOT_DIR" ]; then
    if [ -L "$COPILOT_DIR" ]; then
        echo "Existing Copilot configuration is a symbolic link. Removing it."
        rm "$COPILOT_DIR"
    else
        echo "Existing Copilot configuration found. Backing up to $BACKUP_DIR"
        mv "$COPILOT_DIR" "$BACKUP_DIR"
        echo "Backup completed."
        BACKUP_RUN=true
    fi
fi

# Find the root directory of the ai-dotfiles repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Error: This script must be run from within a git repository."
    exit 1
fi

# Create a symbolic link to the new Copilot configuration
echo "Creating symbolic link for Copilot configuration..."
ln -s "$REPO_ROOT/.config/copilot" "$COPILOT_DIR"

# If a backup was made, copy over all files and directories except those managed by the repo
if [ "$BACKUP_RUN" = true ]; then
    echo "Copying over existing configuration files to the new Copilot configuration directory..."
    mkdir -p "$COPILOT_DIR"
    BACKUP_SOURCE="$BACKUP_DIR/.copilot"
    for item in "$BACKUP_SOURCE"/* "$BACKUP_SOURCE"/.[!.]* "$BACKUP_SOURCE"/..?*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        case "$name" in
            agents|instructions|skills)
                continue
                ;;
        esac
        cp -r "$item" "$COPILOT_DIR"/
    done
    echo "Configuration files copied successfully."
fi

echo "Copilot configuration has been set up successfully."
echo "You can find the new configuration at $COPILOT_DIR"
