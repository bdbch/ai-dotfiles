#!/bin/bash

CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.backups/.claude_backup_$(date +%Y%m%d%H%M%S)"
BACKUP_RUN=false

# Migrate / Backup old opensource folder
mkdir -p "$BACKUP_DIR"
if [ -d "$CLAUDE_DIR" ]; then
    # If the existing configuration is a symbolic link, we can remove it without backup
    if [ -L "$CLAUDE_DIR" ]; then
        echo "Existing Claude configuration is a symbolic link. Removing it."
        rm "$CLAUDE_DIR"
    else
        echo "Existing Claude configuration found. Backing up to $BACKUP_DIR"
        mv "$CLAUDE_DIR" "$BACKUP_DIR"
        echo "Backup completed."
        BACKUP_RUN=true
    fi
fi

# Migrate / Backup old CLAUDE.md file
if [ -f "$HOME/CLAUDE.md" ]; then
    if [ -L "$HOME/CLAUDE.md" ]; then
        echo "Existing CLAUDE.md file is a symbolic link. Removing it."
        rm "$HOME/CLAUDE.md"
    else
        echo "Existing CLAUDE.md file found. Backing up to $BACKUP_DIR"
        mv "$HOME/CLAUDE.md" "$BACKUP_DIR"
    fi
    echo "Backup completed."
fi

# Find the root directory of the ai-dotfiles repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Error: This script must be run from within a git repository."
    exit 1
fi

# Create a symbolic link to the new Claude configuration
echo "Creating symbolic link for Claude configuration..."
ln -s "$REPO_ROOT/.config/claude" "$CLAUDE_DIR"

# Create symlink from AGENTS.md to CLAUDE.md if the CLAUDE.md does not exist but AGENTS.md does
echo "Checking for existing AGENTS.md and CLAUDE.md files..."
if [ ! -f "$HOME/CLAUDE.md" ] && [ -f "$REPO_ROOT/AGENTS.md" ]; then
    echo "Creating symbolic link from AGENTS.md to CLAUDE.md..."
    ln -s "$REPO_ROOT/AGENTS.md" "$HOME/CLAUDE.md"
fi

# If a backup was made, we have to copy over all files and directories except the folders and directories `agents`, `skills` and the `settings.json`
if [ "$BACKUP_RUN" = true ]; then
    echo "Copying over existing configuration files to the new Claude configuration directory..."
    mkdir -p "$CLAUDE_DIR"
    BACKUP_SOURCE="$BACKUP_DIR/.claude"
    for item in "$BACKUP_SOURCE"/* "$BACKUP_SOURCE"/.[!.]* "$BACKUP_SOURCE"/..?*; do
        [ -e "$item" ] || continue
        name="$(basename "$item")"
        case "$name" in
            agents|skills|settings.json)
                continue
                ;;
        esac
        cp -r "$item" "$CLAUDE_DIR"/
    done
    echo "Configuration files copied successfully."
fi

echo "Claude configuration has been set up successfully."
echo "You can find the new configuration at $CLAUDE_DIR"