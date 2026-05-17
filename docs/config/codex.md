# Codex Configuration

The Codex configuration lives in `.config/codex/` and uses TOML format for agent definitions.

## File Structure

```
.config/codex/
├── AGENTS.md              # Agent working style rules
├── <name>.toml            # Agent definitions (16 agents in TOML)
└── skills ->              # Symlink to skills/
```

## Agent Format

Codex uses TOML instead of Markdown for agent definitions. Example:

```toml
name = "code-reviewer"
description = "Structured code review focused on correctness, security, and best practices."
developer_instructions = """
Review code like an owner.
Prioritize correctness, security, behavior regressions, and missing test coverage.
Provide structured reports with severity levels: Critical, Major, Minor, Suggestion.
Be constructive and specific — include line-level feedback when possible.
"""
```

### Available Codex Agents

- accessibility-auditor
- api-dx-reviewer
- architecture-planner
- browser-tester
- code-reviewer
- codebase-explorer
- dependency-upgrade-scout
- design-reviewer
- documentation-writer
- issue-triage-agent
- peer-programmer
- performance-investigator
- regression-hunter
- test-strategist
- typescript-type-reviewer

## Skills

The `skills/` directory in Codex is a symlink to the shared `skills/` directory, ensuring skills are always up-to-date without manual copying.

## Working Style

The shared working style from `AGENTS.md` is included in the Codex config, providing the same peer-programming workflow as opencode and Claude.
