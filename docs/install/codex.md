# Codex Install

The Codex installer creates symlinks for the config directory and skills.

## Installer Script

The installer:
1. Backs up any existing `~/.codex` directory
2. Creates symlink: `~/.codex -> <repo>/.config/codex`
3. Creates `~/.agents/` directory if needed
4. Creates symlink: `~/.agents/skills -> <repo>/skills`

## What It Does

| Source | Target |
|--------|--------|
| `<repo>/.config/codex` | `~/.codex` |
| `<repo>/skills` | `~/.agents/skills` |

## Manual Equivalent

```bash
mv ~/.codex ~/.codex-backup 2>/dev/null; true
ln -s /path/to/ai-dotfiles/.config/codex ~/.codex
mkdir -p ~/.agents
ln -s /path/to/ai-dotfiles/skills ~/.agents/skills
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.
