# ai-dotfiles

Personal AI tooling configurations — currently focused on [opencode](https://opencode.ai).

## Contents

- **opencode config** — `.config/opencode/` with Chrome MCP plugin, custom agents, and skills
- **Claude config** — `.config/claude/` with custom agents and skills
- **Codex config** — `.config/codex/` with TOML agents, skills symlink, and AGENTS.md
- **Custom agents** — 13 specialized agents for code review, architecture planning, browser testing, documentation, performance investigation, and more
- **Skills** — 4 reusable skill bundles (browser debugging, design review, testing, code review)
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

All 13 agents live in `agents/` and are available in opencode:

| Agent | Description |
|-------|-------------|
| api-dx-reviewer | Review public API surfaces (functions, hooks, exports) |
| architecture-planner | Design modules, evaluate tradeoffs before coding |
| browser-tester | Manual end-to-end browser testing |
| code-reviewer | Structured code review with severity levels |
| codebase-explorer | Map out project structure and conventions |
| dependency-upgrade-scout | Investigate dependency issues and plan upgrades |
| design-reviewer | UI/UX design critique |
| documentation-writer | Write API docs, READMEs, JSDoc, migration guides |
| issue-triage-agent | Classify and prioritize incoming issues |
| performance-investigator | Debug page load, Core Web Vitals, bundle size |
| regression-hunter | Detect ripple effects after bugfixes or refactors |
| test-strategist | Plan test coverage for features and modules |
| typescript-type-reviewer | Review TypeScript types for correctness and safety |

## Skills

4 skill bundles in `skills/`:

- **Browser Debug** — Diagnose console errors, network issues, performance regressions
- **Browser Design Review** — Senior UI/UX design critique
- **Browser Test** — Manual end-to-end feature testing via Chrome
- **Code Review** — Best practices, bug detection, code quality feedback

## Configuration

The main config is `opencode.json`. Current setup:

- Default agent: `plan` (starts every conversation in planning mode)
- Chrome DevTools MCP: enabled via `chrome-devtools-mcp`
