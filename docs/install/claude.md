# Claude Install

The Claude installer creates symlinks for both the config directory and the working style file.

## Installer Script

The installer:
1. Backs up any existing `~/.claude` directory
2. Creates symlink: `~/.claude -> <repo>/.config/claude`
3. Creates symlink: `~/CLAUDE.md -> <repo>/AGENTS.md`

## What It Does

| Source | Target |
|--------|--------|
| `<repo>/.config/claude` | `~/.claude` |
| `<repo>/AGENTS.md` | `~/CLAUDE.md` |

## Manual Equivalent

```bash
mv ~/.claude ~/.claude-backup
ln -s /path/to/ai-dotfiles/.config/claude ~/.claude
ln -s /path/to/ai-dotfiles/AGENTS.md ~/CLAUDE.md
```

Replace `/path/to/ai-dotfiles` with the actual path to this repository.
