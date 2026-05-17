![AI DOTFILES COVER](.github/assets/cover.png)

# ai-dotfiles

Personal AI tooling configurations for [opencode](https://opencode.ai), Claude Desktop, and Codex — 18 agents, 5 skills, shared peer-programming workflow.

[📖 Read the docs](https://bdbch.github.io/ai-dotfiles/)

## Quick Install

```bash
sh ./installers/opencode.sh   # opencode
sh ./installers/claude.sh     # Claude Desktop
sh ./installers/codex.sh      # Codex
```

Then install dependencies:

```bash
cd ~/.config/opencode && npm install
```

See the [installation guide](https://bdbch.github.io/ai-dotfiles/install/) for full instructions.

## What's Inside

- **18 agents** — code review, architecture, browser testing, security, design, docs, and more
- **5 skill bundles** — browser debug, design review, accessibility audit, testing, code review
- **Multi-platform** — same config shared across opencode, Claude, and Codex via symlinks
- **MCP integrations** — Chrome DevTools (always on), Linear, GitHub, Notion (pre-configured, opt-in via `opencode.json`)

Browse agents, skills, and config in the [documentation](https://bdbch.github.io/ai-dotfiles/).
