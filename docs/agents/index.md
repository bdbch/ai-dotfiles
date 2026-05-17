# Agents

All 18 agents live in `agents/` and are available in opencode. They share a common peer-programming workflow defined in `AGENTS.md`.

## Agent Categories

| Category | Agents |
|----------|--------|
| **Quality** | [Code Reviewer](/agents/code-reviewer), [Security Reviewer](/agents/security-reviewer), [Accessibility Auditor](/agents/accessibility-auditor), [API DX Reviewer](/agents/api-dx-reviewer), [TypeScript Type Reviewer](/agents/typescript-type-reviewer) |
| **Planning** | [Architecture Planner](/agents/architecture-planner), [Test Strategist](/agents/test-strategist), [Regression Hunter](/agents/regression-hunter) |
| **Testing** | [Browser Tester](/agents/browser-tester), [Performance Investigator](/agents/performance-investigator) |
| **Design** | [Design Reviewer](/agents/design-reviewer), [Design Polish Reviewer](/agents/design-polish-reviewer) |
| **Content** | [Documentation Writer](/agents/documentation-writer), [Idea Finder](/agents/idea-finder) |
| **Triage** | [Issue Triage Agent](/agents/issue-triage-agent), [Dependency Upgrade Scout](/agents/dependency-upgrade-scout) |
| **Explore** | [Codebase Explorer](/agents/codebase-explorer) |
| **Coding** | [Peer Programmer](/agents/peer-programmer) |

## Shared Definitions

The same agent definitions are available in all three supported tools:

| Tool | Format | Path |
|------|--------|------|
| opencode | Markdown | `agents/<name>.md` |
| Claude Desktop | Markdown | `.config/claude/agents/<name>.md` |
| Codex | TOML | `.config/codex/<name>.toml` |

## All Agents

- [Accessibility Auditor](/agents/accessibility-auditor) — WCAG 2.1 AA compliance audits using Chrome MCP
- [API DX Reviewer](/agents/api-dx-reviewer) — Public API surface reviews for libraries and modules
- [Architecture Planner](/agents/architecture-planner) — Design and evaluate architectural decisions before coding
- [Browser Tester](/agents/browser-tester) — Manual end-to-end testing via Chrome MCP
- [Code Reviewer](/agents/code-reviewer) — Structured code reviews with severity levels
- [Codebase Explorer](/agents/codebase-explorer) — Map out codebase structure, wiring, and conventions
- [Dependency Upgrade Scout](/agents/dependency-upgrade-scout) — Investigate dependency-related bugs and plan upgrades
- [Design Polish Reviewer](/agents/design-polish-reviewer) — Senior visual design critique with opinionated feedback
- [Design Reviewer](/agents/design-reviewer) — UI/UX design review for usability and consistency
- [Documentation Writer](/agents/documentation-writer) — Produce and improve technical documentation
- [Idea Finder](/agents/idea-finder) — Creative product thinking and feature ideation
- [Issue Triage Agent](/agents/issue-triage-agent) — Classify and prioritize incoming issues
- [Peer Programmer](/agents/peer-programmer) — One-step-at-a-time pair programming
- [Performance Investigator](/agents/performance-investigator) — Diagnose load time, jank, and Core Web Vitals
- [Regression Hunter](/agents/regression-hunter) — Identify ripple effects after bugfixes and refactors
- [Security Reviewer](/agents/security-reviewer) — Application security review with JSON output
- [Test Strategist](/agents/test-strategist) — Plan test coverage at unit, integration, and e2e levels
- [TypeScript Type Reviewer](/agents/typescript-type-reviewer) — Review TypeScript types for safety and precision
