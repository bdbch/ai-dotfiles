# Getting Started

> **Important:** You need to run the installers out of the actual git repository. If you just downloaded the zip, run `git init` in the `ai-dotfiles` root directory first.

## Installation

Choose your AI tool below and run the corresponding installer:

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

## Dependencies

After installing, install the opencode plugin dependencies:

```bash
cd ~/.config/opencode && npm install
```

This installs the opencode plugin system and Chrome DevTools MCP integration.

## Verify

Check that the symlinks are in place:

```bash
ls -la ~/.config/opencode
ls ~/.config/opencode/node_modules/.package-lock.json
```
