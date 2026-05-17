# Installation

AI Dotfiles uses symlinks to keep configuration in one place while making it available to all three AI tools.

> **Important:** You need to run the installers within the git repository. If you just downloaded the zip, run `git init` in the repo root first.

## Quick Install

| Tool | Command |
|------|---------|
| opencode | `sh ./installers/opencode.sh` |
| Claude | `sh ./installers/claude.sh` |
| Codex | `sh ./installers/codex.sh` |

## Dependencies

After running the installer, install opencode plugin dependencies:

```bash
cd ~/.config/opencode && npm install
```

## Verify

```bash
ls -la ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```

## What Each Installer Does

- [Opencode Install](/install/opencode) — Backup existing config, create symlink
- [Claude Install](/install/claude) — Backup existing config, create symlinks
- [Codex Install](/install/codex) — Backup existing config, create symlinks for config and skills
- [Manual Install](/install/manual) — Step-by-step manual symlink setup without installers
