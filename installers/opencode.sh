#!/bin/bash

OPENCODE_DIR="$HOME/.config/opencode"
BACKUP_DIR="$HOME/.backups/.config/opencode_backup_$(date +%Y%m%d%H%M%S)"

# Find the root directory of the ai-dotfiles repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Error: This script must be run from within a git repository."
    exit 1
fi

# Backup existing config
mkdir -p "$BACKUP_DIR"
if [ -e "$OPENCODE_DIR" ] || [ -L "$OPENCODE_DIR" ]; then
    if [ -L "$OPENCODE_DIR" ]; then
        echo "Existing opencode configuration is a symbolic link. Removing it."
        rm "$OPENCODE_DIR"
    else
        echo "Existing opencode configuration found. Backing up to $BACKUP_DIR"
        mv "$OPENCODE_DIR" "$BACKUP_DIR"
        echo "Backup completed."
    fi
fi

# Create config directory
mkdir -p "$OPENCODE_DIR"

# Symlink configuration files
ln -s "$REPO_ROOT/opencode.jsonc" "$OPENCODE_DIR/opencode.jsonc"
ln -s "$REPO_ROOT/opencode.base.json" "$OPENCODE_DIR/opencode.base.json"
[ -L "$OPENCODE_DIR/AGENTS.md" ] && rm "$OPENCODE_DIR/AGENTS.md"
ln -s "$REPO_ROOT/_AGENTS.md" "$OPENCODE_DIR/AGENTS.md"
ln -s "$REPO_ROOT/agents" "$OPENCODE_DIR/agents"
ln -s "$REPO_ROOT/skills" "$OPENCODE_DIR/skills"

# Copy the package.json for npm dependencies
cp "$REPO_ROOT/opencode.package.json" "$OPENCODE_DIR/package.json"

# Copy the base config as personal config if none exists yet
if [ ! -f "$OPENCODE_DIR/opencode.json" ]; then
    cp "$REPO_ROOT/opencode.base.json" "$OPENCODE_DIR/opencode.json"
fi

# Create secrets directory (real dir, not symlinks — tokens must stay out of the repo)
mkdir -p "$OPENCODE_DIR/.secrets"
chmod 700 "$OPENCODE_DIR/.secrets"
touch "$OPENCODE_DIR/.secrets/github-pat"
chmod 600 "$OPENCODE_DIR/.secrets/github-pat"

# Install plugin dependencies
cd "$OPENCODE_DIR" && npm install

echo "Opencode configuration has been set up successfully."
echo "You can find the new configuration at $OPENCODE_DIR"
