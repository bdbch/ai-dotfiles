![AI DOTFILES COVER](.github/assets/cover.png)

# ai-dotfiles

Personal AI tooling configurations — currently focused on [opencode](https://opencode.ai).

## Contents

- **opencode config** — `.config/opencode/` with Chrome MCP plugin, custom agents, and skills
- **Claude config** — `.config/claude/` with custom agents and skills
- **Codex config** — `.config/codex/` with TOML agents, skills symlink, and AGENTS.md
- **Custom agents** — Specialized agents for code review, architecture planning, browser testing, documentation, performance investigation, and more
- **Skills** — Reusable skill bundles (browser debugging, design review, testing, code review)
- **Agent working style** — shared peer-programming rules in `AGENTS.md`

## Installation

> **IMPORTANT**: You need to run the installers out of the actual git repository. If you just downloaded the zip, run `git init` in the ai-dotfiles root directory

### opencode

```bash
sh ./installers/opencode.sh
```

### Claude

```bash
sh ./installers/claude.sh
```

### Codex

```bash
sh ./installers/codex.sh
```

## Manual Installation

### opencode

```bash
mv ~/.config/opencode ~/.config/opencode_backup
ln -s /path/to/ai-dotfiles/.config/opencode ~/.config/opencode
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.

### Claude

```bash
mv ~/.claude ~/.claude-backup
ln -s /path/to/ai-dotfiles/.config/claude ~/.claude
ln -s /path/to/ai-dotfiles/AGENTS.md ~/CLAUDE.md
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.

### Codex

```bash
mv ~/.codex ~/.codex-backup 2>/dev/null; true
ln -s /path/to/ai-dotfiles/.config/codex ~/.codex
mkdir -p ~/.agents
ln -s /path/to/ai-dotfiles/skills ~/.agents/skills
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.

### Dependencies

```bash
cd ~/.config/opencode && npm install
```

This installs the opencode plugin system and Chrome DevTools MCP integration.

### Verify

```bash
ls -la ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```

## Custom Agents

All agents live in [`agents/`](agents/) and are available in opencode.

## Skills

Skill bundles live in [`skills/`](skills/).

## MCPs

MCP configuration is in [`.config/opencode/opencode.json`](.config/opencode/opencode.json). Chrome DevTools MCP is enabled by default. Linear and Notion MCPs are included but disabled — toggle them via `/mcps` in opencode. On first run, Notion requires OAuth login via `opencode mcp auth Notion`.

## Configuration

The main config is `opencode.json`. Current setup:

- Default agent: `plan` (starts every conversation in planning mode)
