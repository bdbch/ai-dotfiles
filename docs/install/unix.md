# UNIX Installation (Linux / macOS)

> **Important:** You need to run the installer within the git repository. If you just downloaded the zip, run `git init` in the repo root first.

## Quick Install

Run the installer script from the repository root:

```bash
sh ./installers/opencode.sh
```

The installer:

1. Backs up any existing configuration to `~/.backups/`
2. Creates individual symlinks from `~/.config/opencode/` to the repo files
3. Copies `opencode.base.json` to `opencode.json` on first run (your editable config, safe from overwrites)
4. Installs opencode plugin dependencies via npm

### What gets linked

| File/Dir | Symlink Target |
|----------|---------------|
| `opencode.jsonc` | `opencode.jsonc` |
| `opencode.base.json` | `opencode.base.json` |
| `AGENTS.md` | `instructions/README.md` |
| `instructions/` | `instructions/` |
| `agents/` | `agents/` |
| `skills/` | `skills/` |

These are all symlinks — edits in either location stay in sync.

## Manual Install

If you prefer to set up symlinks by hand:

```bash
# Back up any existing config first
mv ~/.config/opencode ~/.config/opencode_backup

# Create the config directory
mkdir -p ~/.config/opencode

# Symlink configuration files
ln -s /path/to/ai-dotfiles/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -s /path/to/ai-dotfiles/opencode.base.json ~/.config/opencode/opencode.base.json
ln -s /path/to/ai-dotfiles/instructions/README.md ~/.config/opencode/AGENTS.md
ln -s /path/to/ai-dotfiles/instructions ~/.config/opencode/instructions
ln -s /path/to/ai-dotfiles/agents ~/.config/opencode/agents
ln -s /path/to/ai-dotfiles/skills ~/.config/opencode/skills

# Create a personal config from the base template
cp /path/to/ai-dotfiles/opencode.base.json ~/.config/opencode/opencode.json
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
ls ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```
