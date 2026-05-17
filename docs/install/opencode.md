# Opencode Install

The opencode installer creates a symlink from `~/.config/opencode` to the repo's `.config/opencode`.

## Installer Script

```bash
#!/bin/bash

OPENCODE_DIR="$HOME/.config/opencode"
BACKUP_DIR="$HOME/.backups/.config/opencode_backup_$(date +%Y%m%d%H%M%S)"

# Migrate / Backup old opencode folder
mkdir -p "$BACKUP_DIR"
if [ -d "$OPENCODE_DIR" ]; then
    if [ -L "$OPENCODE_DIR" ]; then
        echo "Existing opencode config is a symlink. Removing it."
        rm "$OPENCODE_DIR"
    else
        echo "Existing opencode config found. Backing up to $BACKUP_DIR"
        mv "$OPENCODE_DIR" "$BACKUP_DIR"
        echo "Backup completed."
    fi
fi

# Find the repo root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO_ROOT" ]; then
    echo "Error: This script must be run from within a git repository."
    exit 1
fi

# Create symlink
ln -s "$REPO_ROOT/.config/opencode" "$OPENCODE_DIR"
echo "Opencode configuration has been set up successfully."
```

## What It Does

1. Creates a backup directory at `~/.backups/.config/`
2. Backs up any existing opencode config (unless it's already a symlink)
3. Detects the repo root via `git rev-parse --show-toplevel`
4. Creates a symlink: `~/.config/opencode -> <repo>/.config/opencode`
