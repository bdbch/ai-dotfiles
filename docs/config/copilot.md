# Copilot Configuration

The GitHub Copilot / VS Code configuration lives in `.config/copilot/` and shares the same source agent definitions as opencode.

## File Structure

```
.config/copilot/
├── agents/ -> ../../agents/                    # Symlink to shared agent definitions
└── instructions/
    └── AGENTS.instructions.md -> ../../../AGENTS.md  # Symlink to shared working style
```

## Agent Support

Copilot supports the same 20 agents as opencode, defined via dual frontmatter in the source `agents/*.md` files. Each agent includes a `tools` field that controls which Copilot tools the agent can use:

| Tool | Purpose |
|------|---------|
| `web/fetch` | Browse the web |
| `search/codebase` | Semantic code search |
| `search/usages` | Find references and usages |
| `search/grep` | Regex text search |
| `read` | Read files |
| `edit` | Edit files |
| `terminal/run` | Run terminal commands |
| `vscode/askQuestions` | Ask the user questions |

Agents with `permission.edit: deny` only get read-only tools. The `peer-programmer` agent is the only one with `edit` access.

## Working Style

The shared working style from `AGENTS.md` is symlinked into `instructions/` as `AGENTS.instructions.md`, making it available as a user-level instruction file across all workspaces.

## Installation

Run the installer to symlink the configuration to `~/.copilot/`:

```bash
# From the ai-dotfiles repository root
bash installers/copilot.sh
```

The installer backs up any existing `~/.copilot/` directory and restores user-specific files (excluding `agents/`, `instructions/`, and `skills/`).
