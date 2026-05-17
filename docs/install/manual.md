# Manual Installation

If you prefer not to use the installer scripts, you can set up symlinks manually.

## Prerequisites

Make sure you're in the git repository root:

```bash
cd /path/to/ai-dotfiles
git rev-parse --show-toplevel  # should print the repo path
```

## opencode

```bash
mv ~/.config/opencode ~/.config/opencode_backup
ln -s /path/to/ai-dotfiles/.config/opencode ~/.config/opencode
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.

## Claude

```bash
mv ~/.claude ~/.claude-backup
ln -s /path/to/ai-dotfiles/.config/claude ~/.claude
ln -s /path/to/ai-dotfiles/AGENTS.md ~/CLAUDE.md
```

## Codex

```bash
mv ~/.codex ~/.codex-backup 2>/dev/null; true
ln -s /path/to/ai-dotfiles/.config/codex ~/.codex
mkdir -p ~/.agents
ln -s /path/to/ai-dotfiles/skills ~/.agents/skills
```

## Dependencies

```bash
cd ~/.config/opencode && npm install
```

This installs the opencode plugin system and Chrome DevTools MCP integration.

## Verify

```bash
ls -la ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```
