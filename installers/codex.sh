#!/bin/bash

CODEX_DIR="$HOME/.codex"
AGENTS_DIR="$HOME/.agents"
SKILLS_LINK="$AGENTS_DIR/skills"

TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_BASE_DIR="$HOME/.backups"
CODEX_BACKUP_DIR="$BACKUP_BASE_DIR/.codex_backup_$TIMESTAMP"
SKILLS_BACKUP_DIR="$BACKUP_BASE_DIR/.agents_skills_backup_$TIMESTAMP"

# Find the root directory of the ai-dotfiles repository
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
	echo "Error: This script must be run from within a git repository."
	exit 1
fi

CODEX_SOURCE="$REPO_ROOT/.config/codex"
SKILLS_SOURCE="$REPO_ROOT/skills"

if [ ! -d "$CODEX_SOURCE" ]; then
	echo "Error: Codex source directory not found at $CODEX_SOURCE"
	exit 1
fi

if [ ! -d "$SKILLS_SOURCE" ]; then
	echo "Error: Skills source directory not found at $SKILLS_SOURCE"
	exit 1
fi

mkdir -p "$BACKUP_BASE_DIR"

# Backup or remove existing ~/.codex before linking
if [ -e "$CODEX_DIR" ] || [ -L "$CODEX_DIR" ]; then
	if [ -L "$CODEX_DIR" ]; then
		echo "Existing Codex configuration is a symbolic link. Removing it."
		rm "$CODEX_DIR"
	else
		echo "Existing Codex configuration found. Backing up to $CODEX_BACKUP_DIR"
		mv "$CODEX_DIR" "$CODEX_BACKUP_DIR"
		echo "Backup completed."
	fi
fi

echo "Creating symbolic link for Codex configuration..."
ln -s "$CODEX_SOURCE" "$CODEX_DIR"

mkdir -p "$AGENTS_DIR"

# Backup or remove existing ~/.agents/skills before linking
if [ -e "$SKILLS_LINK" ] || [ -L "$SKILLS_LINK" ]; then
	if [ -L "$SKILLS_LINK" ]; then
		echo "Existing Codex skills link found. Removing it."
		rm "$SKILLS_LINK"
	else
		echo "Existing Codex skills directory found. Backing up to $SKILLS_BACKUP_DIR"
		mv "$SKILLS_LINK" "$SKILLS_BACKUP_DIR"
		echo "Backup completed."
	fi
fi

echo "Creating symbolic link for Codex skills..."
ln -s "$SKILLS_SOURCE" "$SKILLS_LINK"

echo "Codex configuration has been set up successfully."
echo "You can find the new configuration at $CODEX_DIR"
echo "You can find the linked skills at $SKILLS_LINK"
