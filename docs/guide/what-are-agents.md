# What Are Agents

Agents in the AI Dotfiles project are **reusable AI personas** — predefined instructions that shape how an AI tool behaves when given a task.

Each agent defines:

- **Role** — what the agent specializes in (e.g., code reviewer, architect, tester)
- **Behavior** — how it approaches tasks, communicates, and structures output
- **Permissions** — what it can or cannot do (edit files, run commands, browse the web)
- **Mode** — whether it works autonomously, requires approval, or follows the peer-programming workflow

## Shared Configuration

The same agent definitions are available in all three AI tools:

| Tool | Agent Format | Location |
|------|-------------|----------|
| opencode | Markdown | `agents/<name>.md` |
| Claude | Markdown | `.config/claude/agents/<name>.md` |
| Codex | TOML | `.config/codex/<name>.toml` |

## Agent Types

| Category | Agents |
|----------|--------|
| **Quality** | code-reviewer, security-reviewer, accessibility-auditor, api-dx-reviewer, typescript-type-reviewer |
| **Planning** | architecture-planner, test-strategist, regression-hunter |
| **Testing** | browser-tester, performance-investigator |
| **Design** | design-reviewer, design-polish-reviewer |
| **Content** | documentation-writer, idea-finder |
| **Triage** | issue-triage-agent, dependency-upgrade-scout |
| **Explore** | codebase-explorer |
| **Coding** | peer-programmer |

Browse the full list in the [Agents](/agents/) section.
