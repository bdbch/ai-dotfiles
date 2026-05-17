# UNIX Installation (Linux / macOS)

> **Important:** You need to run the installers within the git repository. If you just downloaded the zip, run `git init` in the repo root first.

## Quick Install

Run the installer scripts from the repository root:

```bash
sh ./installers/opencode.sh   # opencode
sh ./installers/claude.sh     # Claude Desktop
sh ./installers/codex.sh      # Codex
```

Each installer:
1. Backs up any existing configuration to `~/.backups/`
2. Creates a symlink from the tool's config directory to the repo

### Opencode

Creates: `~/.config/opencode → <repo>/.config/opencode`

### Claude

Creates:
- `~/.claude → <repo>/.config/claude`
- `~/CLAUDE.md → <repo>/AGENTS.md`

### Codex

Creates:
- `~/.codex → <repo>/.config/codex`
- `~/.agents/skills → <repo>/skills`

## Manual Install

If you prefer to set up symlinks by hand:

### opencode

```bash
mv ~/.config/opencode ~/.config/opencode_backup
ln -s /path/to/ai-dotfiles/.config/opencode ~/.config/opencode
```

### Claude

```bash
mv ~/.claude ~/.claude-backup
ln -s /path/to/ai-dotfiles/.config/claude ~/.claude
ln -s /path/to/ai-dotfiles/AGENTS.md ~/CLAUDE.md
```

### Codex

```bash
mv ~/.codex ~/.codex-backup 2>/dev/null; true
ln -s /path/to/ai-dotfiles/.config/codex ~/.codex
mkdir -p ~/.agents
ln -s /path/to/ai-dotfiles/skills ~/.agents/skills
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.

## Dependencies

After installing, install the opencode plugin dependencies:

```bash
cd ~/.config/opencode && npm install
```

This installs the opencode plugin system and Chrome DevTools MCP integration.

## Verify

```bash
ls -la ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```
